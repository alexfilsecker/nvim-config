-- This pluggin allows me to maximize a split temporarily in an easy way

return {
  "szw/vim-maximizer",
  keys = {
    {
      "<leader>sm",
      "<cmd>MaximizerToggle<CR>",
      desc = "Maximize/minimize a split",
    },
  },
}
