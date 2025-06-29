-- This plugin is for searching anything

return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.6",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
  },

  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        path_display = { "smart" }, -- Shows only the necesary part of the path
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, --move to prev result
            ["<C-j>"] = actions.move_selection_next, --move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- No clue what this does
          },
        },
      },
    })

    -- Load fzf for finding in a fuzzy way
    telescope.load_extension("fzf")

    -- Set keymaps
    local keymap = vim.keymap -- For conciseness

    keymap.set(
      "n",
      "<leader>ff",
      "<cmd>Telescope find_files<CR>",
      { desc = "Fuzzy find files in cwd" }
    )
    keymap.set(
      "n",
      "<leader>fr",
      "<cmd>Telescope oldfiles<CR>",
      { desc = "Fuzzy find recent files" }
    )
    keymap.set(
      "n",
      "<leader>fs",
      "<cmd>Telescope live_grep<CR>",
      { desc = "Find string in cwd" }
    )
    keymap.set(
      "n",
      "<leader>fc",
      "<cmd>Telescope grep_string<CR>",
      { desc = "Find string under cursor in cwd" }
    )
    keymap.set(
      "n",
      "<leader>fh",
      "<cmd>Telescope help_tags<CR>",
      { desc = "Search across help" }
    )
    keymap.set(
      "n",
      "<leader>ft",
      "<cmd>TodoTelescope<cr>",
      { desc = "Find todos" }
    )
  end,
}
