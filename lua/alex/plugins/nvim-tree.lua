return {
  "nvim-tree/nvim-tree.lua",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    -- Recommended: disable netrw so nvim-tree behaves properly
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- Aesthetic options (optional)
    vim.opt.termguicolors = true

    require("nvim-tree").setup()


    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set(
      "n",
      "<leader>ee",
      "<cmd>NvimTreeToggle<CR>",
      { desc = "Toggle file explorer" }
    ) -- toggle file explorer
    keymap.set(
      "n",
      "<leader>ec",
      "<cmd>NvimTreeCollapse<CR>",
      { desc = "Collapse file explorer" }
    ) -- collapse file explorer
    keymap.set(
      "n",
      "<leader>er",
      "<cmd>NvimTreeRefresh<CR>",
      { desc = "Refresh file explorer" }
    ) -- refresh file explorer
    keymap.set(
      "n",
      "<leader>ef",
      "<cmd>NvimTreeFindFile<CR>",
      { desc = "Find current file in file explorer" }
    ) -- find current file in file explorer
  end

}
