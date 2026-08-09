return {
  "mrjones2014/smart-splits.nvim",
  event = "VeryLazy",
  config = function()
    local smart_splits = require("smart-splits")
    smart_splits.setup({})

    local keymap = vim.keymap.set
    keymap("n", "<M-h>", smart_splits.resize_left, { desc = "Resize Left" })
    keymap("n", "<M-l>", smart_splits.resize_right, { desc = "Resize Right" })
    keymap("n", "<M-j>", smart_splits.resize_down, { desc = "Resize Down" })
    keymap("n", "<M-k>", smart_splits.resize_up, { desc = "Resize Up" })
  end,
}
