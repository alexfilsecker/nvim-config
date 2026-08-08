-- The LSP servers this config runs, as lspconfig server names.
--
-- Single source of truth for two consumers that must agree:
--   * lua/plugins/mason.lua      -- installs them
--   * lua/plugins/nvim-lspconfig.lua -- configures and enables them
--
-- mason-lspconfig runs with `automatic_enable = false`, so drift between the
-- two is silent in both directions: a name only mason knows installs a server
-- that never starts, and a name only lspconfig knows fails `vim.lsp.enable`
-- without a message.

return {
  "eslint",
  "gopls",
  "lua_ls",
  "pyright",
  "ts_ls",
}
