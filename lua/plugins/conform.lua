-- Here we place all formating related config

return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    -- If falabella disable formating on save
    local formaters_by_ft = {
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

    local formaters = {
      stylua = {
        indent_type = "Spaces",
      },
      black = {
        timeout_ms = 5000,
      },
    }

    conform.setup({
      formatters_by_ft = formaters_by_ft,
      formaters = formaters,
      log_level = vim.log.levels.DEBUG,
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
