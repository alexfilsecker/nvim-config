-- This plugin gives me hints for doing keymaps
-- Just remember to add the `{ desc = "my description" }` field
-- when creating any keymap.

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  dependencies = {
    "echasnovski/mini.icons",
  },
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300 -- ms until the window help appears
  end,
  opts = {
    -- Here we change the default options.
    win = {
      border = "single",
    },
    -- Group labels for every leader prefix. The mappings themselves stay in
    -- the plugin spec that owns them -- lazy.nvim uses `keys` to decide when to
    -- load a plugin, so moving them here would load everything at startup.
    -- Only the labels are centralized, so the tree reads the same everywhere.
    spec = {
      { "<leader>b", group = "buffer" },
      { "<leader>c", group = "code" },
      { "<leader>f", group = "find/file" },
      { "<leader>g", group = "git" },
      { "<leader>gh", group = "hunks" },
      { "<leader>q", group = "quit" },
      { "<leader>s", group = "search" },
      { "<leader>u", group = "ui toggle" },
      { "<leader>w", group = "window" },
      { "<leader>x", group = "lists" },
    },
  },
}
