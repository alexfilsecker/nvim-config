-- This plugin gives me the tab like look of all my tabs

return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    require("bufferline").setup({
      options = {
        diagnostics = "nvim_lsp",
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "left",
          },
          {
            filetype = "snacks_layout_box",
          },
        },
      },
    })

    local keymap = vim.keymap.set

    -- Cycling
    keymap(
      "n",
      "<leader>bn",
      "<cmd>BufferLineCycleNext<CR>",
      { desc = "Next Buffer" }
    )
    keymap(
      "n",
      "<leader>bp",
      "<cmd>BufferLineCyclePrev<CR>",
      { desc = "Previous Buffer" }
    )
    keymap(
      "n",
      "<leader>bb",
      "<cmd>BufferLinePick<CR>",
      { desc = "Pick Buffer" }
    )

    -- Reordering
    keymap(
      "n",
      "<leader>bl",
      "<cmd>BufferLineMoveNext<CR>",
      { desc = "Move buffer to next" }
    )
    keymap(
      "n",
      "<leader>bh",
      "<cmd>BufferLineMovePrev<CR>",
      { desc = "Move buffer to prev" }
    )

    -- Closing
    keymap(
      "n",
      "<leader>bxl",
      "<cmd>BufferLineCloseRight<CR>",
      { desc = "Close buffer to the right" }
    )
    keymap(
      "n",
      "<leader>bxh",
      "<cmd>BufferLineCloseLeft<CR>",
      { desc = "Close buffer to the left" }
    )
    keymap(
      "n",
      "<leader>bxo",
      "<cmd>BufferLineCloseOthers<CR>",
      { desc = "Close all other buffers" }
    )
    keymap(
      "n",
      "<leader>bc",
      "<cmd>BufferLinePickClose<CR>",
      { desc = "Close Buffer" }
    )

    -- Pinning
    keymap(
      "n",
      "<leader>bP",
      "<cmd>BufferLineTogglePin<CR>",
      { desc = "Toggle pin on buffer" }
    )
  end,
}
