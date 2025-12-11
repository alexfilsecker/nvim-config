-- This plugin allows me to highlight and color stuff

return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      -- Enable syntax highlighting
      highlight = {
        enable = true,
        -- disable = { "markdown", "markdown_inline" }
      },

      -- Enable indentation
      indent = { enable = true },

      -- Auto install new languajes
      sync_install = false,
      auto_install = true,
    })
  end,
}
