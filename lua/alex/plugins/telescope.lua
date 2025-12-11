return {
  'nvim-telescope/telescope.nvim', tag = 'v0.2.0',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-smart-history.nvim",
    {
      "kkharji/sqlite.lua",
      build = "make",   -- IMPORTANT: builds the sqlite.so file
    },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        path_display = { "smart" }, -- Shows only the necesary part of the path
        history = {
          path = vim.fn.stdpath("data") .. "/telescope_history",
          limit = 100, -- number of queries to store for each picker
        },
        file_ignore_patterns = {
          "node_modules",
          ".git",
          "dist",
          "build",
          "coverage",
        },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, --move to prev result
            ["<C-j>"] = actions.move_selection_next, --move to next result
          },
        },
      },
    })



    -- Load fzf for finding in a fuzzy way
    telescope.load_extension("fzf")
    telescope.load_extension("smart_history")


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
      "<cmd>Telescope resume<CR>",
      { desc = "Resume last telescope search" }
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
      "<leader>fb",
      "<cmd>Telescope buffers<CR>",
      { desc = "Fuzzy find open buffers in current neovim instance" }
    )

  end
}
