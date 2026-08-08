return {
  {
    "williamboman/mason.nvim",
    config = true,
  },
  -- LSP servers only: these must be lspconfig server names.
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = function()
      return {
        -- Defaults to true, which enables every server mason has installed --
        -- including ones dropped from the list below, and ones installed
        -- ad-hoc via :Mason. Off means nvim-lspconfig.lua's `servers` loop
        -- decides what runs, so servers can't attach without our capabilities
        -- applied.
        automatic_enable = false,
        ensure_installed = require("core.lsp-servers"),
      }
    end,
  },
  -- Everything that isn't an LSP server (linters, formatters). mason.nvim has
  -- no ensure_installed of its own, hence this plugin.
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "gofumpt",
        "goimports",
        "prettier",
        "selene",
        "stylua",
      },
    },
  },
}
