-- Here I setup all keymaps that are not related to any plugins

-- Set leader key
vim.g.mapleader = " "

-- Conciseness
local keymap = vim.keymap

-- Navigate vim panes (same as in tmux)
keymap.set("n", "<C-h>", ":wincmd h<CR>")
keymap.set("n", "<C-j>", ":wincmd j<CR>")
keymap.set("n", "<C-k>", ":wincmd k<CR>")
keymap.set("n", "<C-l>", ":wincmd l<CR>")

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
  "<leader>nh",
  vim.cmd.nohlsearch,
  { desc = "Remove search highlighting" }
)

-- Move whole lines
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { noremap = true })
keymap.set("v", "K", ":m '>-2<CR>gv=gv", { noremap = true })

-- Increment/Decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- increment
