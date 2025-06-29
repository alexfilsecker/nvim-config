return {
  "xiyaowong/link-visitor.nvim",
  config = function()
    local link_visitor = require("link-visitor")
    link_visitor.setup({
      skip_confirmation = true,
    })

    -- Set a keymap to open the link under cursor
    vim.keymap.set(
      "n",
      "<leader>lv",
      "<cmd>VisitLinkUnderCursor<CR>",
      { desc = "Visit link under cursor" }
    )
    -- www.google.com
  end,
}
