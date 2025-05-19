-- This plugin gives me the tab like look of all my tabs

return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  opts = {
    options = {
      mode = "tabs", -- Use tabs, I can also use buffers instead
    },
  },
}
