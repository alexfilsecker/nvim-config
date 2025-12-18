return {
  "mrjones2014/smart-splits.nvim",
  event = "VeryLazy",
  config = function()
    local smart_splits = require("smart-splits")
    smart_splits.setup({})

    local keymap = vim.keymap.set
    keymap("n", "<M-h>", smart_splits.resize_left)
    keymap("n", "<M-l>", smart_splits.resize_right)
    keymap("n", "<M-j>", smart_splits.resize_down)
    keymap("n", "<M-k>", smart_splits.resize_up)
  end,
}
