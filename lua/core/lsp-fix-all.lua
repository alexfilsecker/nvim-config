-- Apply LSP `source.fixAll` synchronously, for use from BufWritePre.
--
-- Lives here rather than in lua/plugins/nvim-lspconfig.lua because conform.nvim
-- is what actually calls it: both plugins used to register their own
-- BufWritePre, and since both lazy-load on BufReadPre, lazy.nvim's load order --
-- not the config -- decided whether prettier or eslint --fix had the last word.
-- One caller, one order. See lua/plugins/conform.lua.

local M = {}

local TIMEOUT_MS = 1000

-- A `source.fixAll` action can legitimately expose further fixes once the first
-- is applied, but each round costs a round trip, so don't chase it forever.
local MAX_ROUNDS = 5

--- Whole-buffer LSP range, in `encoding` character offsets.
local function buf_range(bufnr, encoding)
  local last = vim.api.nvim_buf_line_count(bufnr) - 1
  local text = vim.api.nvim_buf_get_lines(bufnr, last, last + 1, true)[1]
  return {
    start = { line = 0, character = 0 },
    ["end"] = {
      line = last,
      character = vim.lsp.util.character_offset(bufnr, last, #text, encoding),
    },
  }
end

--- Apply every `source.fixAll` action `client` offers for `bufnr`.
local function fix_all(client, bufnr)
  -- Deliberately synchronous. `vim.lsp.buf.code_action({ apply = true })`
  -- returns before the server answers, so in BufWritePre the file gets
  -- written first and the edit arrives afterwards -- missing the file
  -- and leaving the buffer modified right after a save.
  --
  -- Which also means a timeout silently writes the file unfixed, so say so
  -- rather than letting it look like "nothing needed fixing".
  local function request(method, params)
    local res, err = client:request_sync(method, params, TIMEOUT_MS, bufnr)
    local failure = err or (res and res.err and res.err.message)
    if not res or failure then
      vim.notify(
        ("fixAll on save: %s: %s"):format(method, failure or "request failed"),
        vim.log.levels.WARN
      )
      return nil
    end
    return res.result
  end

  for _ = 1, MAX_ROUNDS do
    -- Built from `bufnr`, never the current window: BufWritePre also fires
    -- for buffers that are not current (`:bufdo w`, autosave), and
    -- `make_range_params` takes the URI from whatever window is focused.
    local actions = request("textDocument/codeAction", {
      textDocument = vim.lsp.util.make_text_document_params(bufnr),
      range = buf_range(bufnr, client.offset_encoding),
      context = { only = { "source.fixAll" }, diagnostics = {} },
    })
    if not actions or #actions == 0 then
      return
    end

    -- One action per round, re-requesting in between. Every action in a
    -- response carries the buffer version as of that request, and applying one
    -- bumps `vim.lsp.util.buf_versions`, so anything applied afterwards from
    -- the same response is rejected as stale and dropped without a word.
    local action = actions[1]

    -- A bare `Command` carries `command` as a string; a `CodeAction` has it
    -- as a table, or nil. Only the latter is resolvable, and only when it
    -- arrived with neither an edit nor a command of its own.
    local resolvable = type(action.command) ~= "string"
      and not action.edit
      and not action.command
    if resolvable and client:supports_method("codeAction/resolve", bufnr) then
      action = request("codeAction/resolve", action) or action
    end

    -- Only edits. The spec also lets an action carry a command for the server
    -- to run, but servicing the `workspace/applyEdit` it sends back would mean
    -- mutating the buffer from an RPC handler while we're blocked in
    -- `vim.wait` inside BufWritePre. eslint always answers with an edit, so
    -- this is unreachable today -- say so if that ever stops being true.
    if not action.edit then
      vim.notify(
        ("fixAll on save: %s returned a command-based action, skipped"):format(
          client.name
        ),
        vim.log.levels.WARN
      )
      return
    end

    local before = vim.api.nvim_buf_get_changedtick(bufnr)
    vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)

    -- Nothing left to chase: that was the only action, or applying it changed
    -- nothing and another round would return the same thing.
    if #actions == 1 or vim.api.nvim_buf_get_changedtick(bufnr) == before then
      return
    end
  end
end

--- Run `source.fixAll` over `bufnr`. Safe to call for any buffer.
function M.run(bufnr)
  -- eslint only. ts_ls also advertises `source.fixAll`, but answering it
  -- costs a flat ~500ms per save regardless of whether anything needs
  -- fixing, and what it fixes largely overlaps with eslint's ~12ms. The
  -- <leader>cx keymap in lua/plugins/nvim-lspconfig.lua is the deliberate
  -- opt-in to the thorough, slow version.
  --
  -- This doubles as the filetype gate: it is a scan over the attached
  -- clients, and returns nothing for any buffer eslint never attached to.
  local clients = vim.lsp.get_clients({
    bufnr = bufnr,
    method = "textDocument/codeAction",
    name = "eslint",
  })

  for _, client in ipairs(clients) do
    fix_all(client, bufnr)
  end
end

return M
