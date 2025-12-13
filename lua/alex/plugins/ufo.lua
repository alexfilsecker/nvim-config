return {
  "kevinhwang91/nvim-ufo",
  dependencies = {
    "kevinhwang91/promise-async",
  },
  event = "BufReadPost",
  config = function()
    -- Fold column like the demo
    vim.o.foldcolumn = "1"
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    vim.o.fillchars =
      "eob: ,fold: ,foldopen:,foldsep: ,foldclose:"

    -- Keymaps (must override default zR / zM)
    vim.keymap.set("n", "zR", require("ufo").openAllFolds)
    vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

    -- Optional: preview folds with K, fallback to hover
    vim.keymap.set("n", "K", function()
      local winid = require("ufo").peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end)

    require("ufo").setup({
      -- Provider priority
      provider_selector = function(_, filetype, _)
        -- Use treesitter when available, otherwise indent
        return { "treesitter", "indent" }
      end,

      -- Close imports/comments by default
      close_fold_kinds_for_ft = {
        default = { "imports", "comment" },
      },

      preview = {
        win_config = {
          border = "rounded",
          winblend = 12,
          maxheight = 20,
        },
      },
    })
  end,
}
