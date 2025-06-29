-- This plugin allows me to highlight and color stuff

return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = "windwp/nvim-ts-autotag",
  config = function()
    local configs = require("nvim-treesitter.configs")

    require("nvim-ts-autotag").setup()
    configs.setup({
      -- Enable syntax highlighting
      highlight = { enable = true },

      -- Enable indentation
      indent = { enable = true },

      -- -- Enable autotagging with nvim-ts-autotag-plugin
      -- autotag = { enable = true },

      -- Auto install new languajes
      sync_install = false,
      auto_install = true,

      ensure_installed = {
        "lua",
        "javascript",
        "html",
        "css",
        "typescript",
        "json",
        "tsx",
        "markdown",
        "vim",
        "dockerfile",
        "gitignore",
        "vimdoc",
      },

      -- This allows me to select incrementally, just try it out in normal mode
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    })
  end,
}
