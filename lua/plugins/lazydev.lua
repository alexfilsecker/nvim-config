-- Configures lua_ls for editing this Neovim config. Instead of putting every
-- installed plugin on the workspace library up front, lazydev adds a plugin's
-- `lua/` directory only when a buffer actually requires it. That keeps plugin
-- docs/, tests/ and spec/ files out of the index, which is where the spurious
-- `duplicate-set-field` warnings came from.

return {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      -- Types for `vim.uv`, loaded only when that's referenced.
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      -- snacks sets `_G.Snacks` in its own `lua/snacks/init.lua`, so nothing
      -- here ever `require`s it and the on-demand rule above would never pull
      -- it in. Key off the global instead, otherwise every `Snacks.*` call in
      -- snacks.lua and core/preview-buffer.lua is an `undefined-global`.
      { path = "snacks.nvim", words = { "Snacks" } },
    },
  },
}
