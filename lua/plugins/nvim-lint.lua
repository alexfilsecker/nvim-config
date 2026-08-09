return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufWritePost", "InsertLeave" },
  config = function()
    local lint = require("lint")
    -- No javascript/typescript entry on purpose. The `eslint` language server
    -- is enabled in nvim-lspconfig.lua and already reports ESLint diagnostics
    -- for those buffers, so linting them here would only duplicate them.
    lint.linters_by_ft = {
      lua = { "selene" },
    }

    -- Look up a linter definition by name. `lint.linters` already pcalls the
    -- require behind its __index and yields nil on failure, so this needs no
    -- guard of its own -- but factory linters still have to be called.
    local function resolve(name)
      local linter = lint.linters[name]
      if type(linter) == "function" then
        linter = linter()
      end
      return linter
    end

    -- Skip linters whose executable isn't on PATH. Without this nvim-lint
    -- spawns them regardless and reports "Error running <cmd>: ENOENT" on
    -- every InsertLeave. `cmd` may itself be a function.
    local function is_installed(linter)
      local cmd = linter and linter.cmd
      if type(cmd) == "function" then
        cmd = cmd()
      end
      return cmd ~= nil and vim.fn.executable(cmd) == 1
    end

    -- selene resolves `selene.toml` -- and the `vim.yml` std that file names --
    -- against the process cwd, not the file being linted. Run it from the
    -- directory holding the nearest selene.toml instead, otherwise opening a
    -- config file while nvim sits somewhere else lints it as stock Lua 5.1 and
    -- reports every `vim.*` as an undefined global.
    --
    -- The walk is unbounded -- `vim.fs.find` takes no `stop` here -- so on a
    -- buffer with no selene.toml above it every ancestor up to / gets stat'd.
    -- That runs on every InsertLeave, so cache it against the name it was
    -- computed for; `:saveas` is the only thing that can invalidate it.
    -- `vim.b` can't hold nil, so "" means "looked, found nothing".
    local function selene_root(bufnr)
      local file = vim.api.nvim_buf_get_name(bufnr)
      local cached = vim.b[bufnr].selene_root
      if cached and cached.file == file then
        return cached.root ~= "" and cached.root or nil
      end

      local found = file ~= ""
        and vim.fs.find(
          "selene.toml",
          { path = vim.fs.dirname(file), upward = true }
        )[1]
      local root = found and vim.fs.dirname(found) or nil

      vim.b[bufnr].selene_root = { file = file, root = root or "" }
      return root
    end

    -- Resolve the same way try_lint does. Indexing `linters_by_ft` directly
    -- would return nil for a compound filetype like `markdown.mdx` and report
    -- nothing -- precisely the silent case the <leader>ll warning exists to
    -- catch. `_resolve_linter_by_ft` is private, though, so a rename in a
    -- routine :Lazy update should degrade to the naive lookup, not throw.
    local function linters_for(ft)
      local ok, names = pcall(lint._resolve_linter_by_ft, ft)
      if ok and names then
        return names
      end
      return lint.linters_by_ft[ft] or {}
    end

    local function wrap_linter(linter)
      if linter.name == "selene" then
        linter.cwd = selene_root(vim.api.nvim_get_current_buf()) or linter.cwd
      end
      return linter
    end

    vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
      -- Without a group, `:Lazy reload nvim-lint` (or lazy.nvim's own change
      -- detection) re-runs this config and stacks another handler, so every
      -- InsertLeave would spawn N concurrent selene processes.
      group = vim.api.nvim_create_augroup("nvim_lint", { clear = true }),
      callback = function()
        lint.try_lint(nil, { filter = is_installed, wrap_linter = wrap_linter })
      end,
    })

    vim.keymap.set("n", "<leader>cl", function()
      -- Partition before linting, not after: `lint.try_lint` resolves names
      -- through a bare `assert(linter, ...)`, so an unknown name throws out of
      -- try_lint and the notify below would never run.
      local runnable, not_installed, unknown = {}, {}, {}
      for _, name in ipairs(linters_for(vim.bo.filetype)) do
        if lint.linters[name] == nil then
          table.insert(unknown, name)
        elseif is_installed(resolve(name)) then
          table.insert(runnable, name)
        else
          table.insert(not_installed, name)
        end
      end

      if #runnable > 0 then
        lint.try_lint(runnable, { wrap_linter = wrap_linter })
      end

      -- Asking for linting explicitly should say why nothing happened,
      -- rather than silently doing nothing.
      if #not_installed > 0 then
        vim.notify(
          "Linter not installed: " .. table.concat(not_installed, ", "),
          vim.log.levels.WARN
        )
      end
      if #unknown > 0 then
        vim.notify(
          "Unknown linter: " .. table.concat(unknown, ", "),
          vim.log.levels.WARN
        )
      end
    end, { desc = "Lint File" })
  end,
}
