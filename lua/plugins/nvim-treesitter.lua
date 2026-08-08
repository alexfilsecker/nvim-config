-- Parsers installed up front, so a fresh machine ends up with the same set as
-- every other one. Anything not listed here is still installed on demand the
-- first time its filetype is opened -- the `main` branch dropped `auto_install`,
-- so `ensure` below is that feature, rebuilt on the new API.
local ensure_installed = {
  "css",
  "html",
  "javascript",
  "json",
  "latex",
  "markdown",
  "markdown_inline",
  "regex",
  "scss",
  "svelte",
  "toml",
  "tsx",
  "typst",
  "vue",
  "yaml",

  "bash",
  "c",
  "go",
  "lua",
  "python",
  "typescript",

  "diff",
  "dockerfile",
  "gitcommit",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")
    local ts_config = require("nvim-treesitter.config")

    ts.setup({})

    local installed = {}
    for _, lang in ipairs(ts_config.get_installed("parsers")) do
      installed[lang] = true
    end

    -- `get_available` fires a `User TSUpdate` autocmd on every call, so ask once.
    local available = {}
    for _, lang in ipairs(ts_config.get_available()) do
      available[lang] = true
    end

    -- Installs in flight. Every buffer of a language hits `FileType` before the
    -- parser lands, and without this each one would queue its own install.
    local pending = {}

    --- Attach treesitter to `buf`. Returns whether it took.
    local function start(buf)
      if not vim.api.nvim_buf_is_valid(buf) then
        return false
      end
      local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
      if not lang or not pcall(vim.treesitter.start, buf, lang) then
        return false
      end

      -- Only when the language actually ships an `indents.scm`. Without one,
      -- `nvim-treesitter.indent.get_indent` finds an empty capture map, never
      -- enters an indent/align/dedent branch and returns its initial 0 -- so
      -- `gg=G` would flatten the buffer to column 0 *and* clobber the built-in
      -- indent script we'd otherwise fall back to. This is the guard the old
      -- `indent = { enable = true }` module had. Reached only after
      -- `treesitter.start` succeeded, i.e. once the parser and its queries are
      -- both on the rtp, so the memoized lookup can't cache a stale nil.
      if vim.treesitter.query.get(lang, "indents") then
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
      return true
    end

    --- Install `langs`, then attach every buffer that was waiting on them.
    local function ensure(langs)
      langs = vim.tbl_filter(function(lang)
        return not installed[lang] and not pending[lang] and available[lang]
      end, langs)
      if #langs == 0 then
        return
      end

      for _, lang in ipairs(langs) do
        pending[lang] = true
      end

      -- Installing is a compile, so on a fresh machine this runs for minutes.
      -- Buffers opened meanwhile already failed `start`; nothing would ever
      -- retry them, leaving the whole first session on regex highlighting.
      ts.install(langs, { summary = true }):await(function(err)
        vim.schedule(function()
          for _, lang in ipairs(langs) do
            pending[lang] = nil
          end
          if err then
            vim.notify(
              ("treesitter: installing %s failed: %s"):format(
                table.concat(langs, ", "),
                err
              ),
              vim.log.levels.WARN
            )
            return
          end
          for _, lang in ipairs(langs) do
            installed[lang] = true
          end
          -- Queries just appeared on the rtp; drop what was memoized without
          -- them. `query.get` is a vim.func._memoize object, but pcall it in
          -- case that private detail changes -- a stale cache is survivable.
          pcall(function()
            vim.treesitter.query.get:clear()
          end)
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) then
              start(buf)
            end
          end
        end)
      end)
    end

    ensure(ensure_installed)

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
      callback = function(args)
        if start(args.buf) then
          return
        end
        local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
        if lang then
          ensure({ lang })
        end
      end,
    })
  end,
}
