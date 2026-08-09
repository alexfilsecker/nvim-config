-- Here we place all formating related config

return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    -- If falabella disable formating on save
    local formatters_by_ft = {
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      css = { "prettier" },
      html = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      graphql = { "prettier" },
      liquid = { "prettier" },
      lua = { "stylua" },
      go = { "goimports", "gofumpt" },
    }

    -- No `formatters` override table here on purpose. stylua's own settings
    -- live in .stylua.toml, which is what the binary reads -- conform has no
    -- say in them. Per-formatter `timeout_ms` isn't a thing either; that
    -- belongs to format() / default_format_opts.
    conform.setup({
      formatters_by_ft = formatters_by_ft,
      log_level = vim.log.levels.DEBUG,
    })

    vim.keymap.set({ "n", "v" }, "<leader>cf", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format File or Range" })

    -- The only BufWritePre that rewrites the buffer. LSP `source.fixAll` used
    -- to register its own in nvim-lspconfig.lua, and since both plugins
    -- lazy-load on BufReadPre, lazy.nvim's load order picked the winner: an
    -- eslint autofix that reintroduces something prettier rewrites (or the
    -- reverse) could come out differently on two machines. eslint --fix first,
    -- prettier last so formatting always has the final say.
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("conform_format", { clear = true }),
      pattern = "*",
      callback = function(args)
        require("core.lsp-fix-all").run(args.buf)
        conform.format({ bufnr = args.buf, lsp_fallback = true })
      end,
    })
  end,
}
