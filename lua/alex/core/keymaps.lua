-- Here I setup all keymaps that are not related to any plugins

-- Set leader key
vim.g.mapleader = " "

-- Conciseness
local keymap = vim.keymap

-- Exit insert mode quickly
keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Acces Explorer
keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Acces Explorer" })

-- Navigate vim panes (same as in tmux)
keymap.set("n", "<C-h>", ":wincmd h<CR>")
keymap.set("n", "<C-j>", ":wincmd j<CR>")
keymap.set("n", "<C-k>", ":wincmd k<CR>")
keymap.set("n", "<C-l>", ":wincmd l<CR>")

-- Resize panes
-- Could not make this to be as intuitive as in tmux
-- In tmux, pane resizing works by moving the line between panes
-- Here it makes a pane bigger or smaller so it is not an intuitive motion
keymap.set("n", "<C-M-h>", ":vertical resize -2<CR>")
keymap.set("n", "<C-M-j>", ":resize -2<CR>")
keymap.set("n", "<C-M-k>", ":resize +2<CR>")
keymap.set("n", "<C-M-l>", ":vertical resize +2<CR>")

-- Split views
keymap.set("n", "<leader>s|", vim.cmd.vsplit, { desc = "Do a vertical split" })
keymap.set("n", "<leader>s-", vim.cmd.split, { desc = "Do a horizontal split" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Split equally" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current pane" })

-- Tabing
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set(
  "n",
  "<leader>tx",
  "<cmd>tabclose<CR>",
  { desc = "Close current tab" }
) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set(
  "n",
  "<leader>tf",
  "<cmd>tabnew %<CR>",
  { desc = "Open current buffer in new tab" }
) --  move current buffer to new tab

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
