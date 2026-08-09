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
            filetype = "snacks_layout_box",
          },
        },
      },
    })

    local keymap = vim.keymap.set

    -- Cycling moves to the stock ]b / [b positions, but deliberately keeps
    -- bufferline's implementation rather than the default `:bnext`/`:bprevious`
    -- behind them. The two disagree the moment a buffer is reordered below:
    -- `:bnext` walks buffer numbers, BufferLineCycleNext walks the order
    -- actually drawn in the tabline, which is the one you can see.
    keymap("n", "]b", "<cmd>BufferLineCycleNext<CR>", { desc = "Next Buffer" })
    keymap(
      "n",
      "[b",
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
      { desc = "Move Buffer Right" }
    )
    keymap(
      "n",
      "<leader>bh",
      "<cmd>BufferLineMovePrev<CR>",
      { desc = "Move Buffer Left" }
    )

    -- Closing. The directional variants -- close everything to the left of
    -- here, close everything to the right -- were three-key chords that "close
    -- others" covers well enough.
    keymap(
      "n",
      "<leader>bo",
      "<cmd>BufferLineCloseOthers<CR>",
      { desc = "Close Other Buffers" }
    )
    keymap(
      "n",
      "<leader>bc",
      "<cmd>BufferLinePickClose<CR>",
      { desc = "Close Buffer" }
    )

    -- Pinning
    -- Promote first, so the next explorer open can't close the buffer we just
    -- pinned. This fires on both directions of the toggle, which is harmless:
    -- a pinned buffer was already promoted, so unpinning finds nothing left to
    -- clear. Unpinning deliberately does not hand the buffer back to preview
    -- state -- once permanent, always permanent, like VS Code.
    -- On <leader>bp now that cycling has moved to ]b / [b.
    keymap("n", "<leader>bp", function()
      require("core.preview-buffer").promote()
      vim.cmd("BufferLineTogglePin")
    end, { desc = "Toggle Pin on Buffer" })
  end,
}
