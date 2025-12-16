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
      "<leader>bc",
      "<cmd>BufferLinePickClose<CR>",
      { desc = "Close Buffer" }
    )
  end,
}
