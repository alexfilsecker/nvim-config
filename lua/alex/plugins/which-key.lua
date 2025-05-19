-- This plugin gives me hints for doing keymaps
-- Just remember to add the `{ desc = "my description" }` field
-- when creating any keymap.

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300 -- ms until the window help appears
  end,
  opts = {
    -- Here we change the default options.
    win = {
      border = "single",
    },
  },
}
