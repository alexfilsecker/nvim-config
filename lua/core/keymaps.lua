-- Here I setup all keymaps that are not related to any plugins

-- Set leader key
vim.g.mapleader = " "

-- Conciseness
local keymap = vim.keymap

-- No <C-hjkl> pane navigation here. vim-tmux-navigator maps the same four keys
-- and loads after this file, so anything set here is silently overwritten --
-- and its versions cross into tmux panes, which `:wincmd` cannot do.

-- Split views
keymap.set("n", "<leader>s|", vim.cmd.vsplit, { desc = "Do a vertical split" })
keymap.set("n", "<leader>s-", vim.cmd.split, { desc = "Do a horizontal split" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Split equally" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current pane" })

-- External clipboard
keymap.set(
  { "n", "v" },
  "<leader>y",
  '"+y',
  { desc = "Yank to external clipboard" }
)
keymap.set(
  { "n", "v" },
  "<leader>p",
  '"+p',
  { desc = "Paste from external clipboard" }
)

-- Reset search highlighting
keymap.set(
  "n",
  "<leader>hn",
  vim.cmd.nohlsearch,
  { desc = "Remove search highlighting" }
)

-- Move whole lines. The destinations are deliberately asymmetric: moving down
-- measures from the end of the selection, moving up from its start. Using '>
-- for both makes the up-move a no-op on any selection longer than one line.
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Increment/Decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- increment

-- terminal
keymap.set("t", "<C-x>", "<C-\\><C-n>", { desc = "Exit Terminal Mode" })
keymap.set("n", "<leader>tt", ":terminal<CR>", { desc = "Open Terminal" })
