-- Here I setup all keymaps that are not related to any plugins.
--
-- Every leader mapping in this config, here and in the plugin specs, belongs to
-- exactly one of these groups. The labels which-key shows for them are declared
-- in one place, lua/plugins/which-key.lua:
--
--   <leader>b  buffer      <leader>c  code       <leader>f  find/file
--   <leader>g  git         <leader>q  quit       <leader>s  search
--   <leader>u  UI toggle   <leader>w  window     <leader>x  lists
--
-- Anything a stock Neovim 0.11+ already maps is deliberately left alone rather
-- than re-implemented: `grn` rename, `gra` code action, `grr` references,
-- `gri` implementation, `grt` type definition, `gO` document symbols,
-- `]d`/`[d` diagnostics, `]b`/`[b` buffers, `]q`/`[q` quickfix.

-- Set leader key
vim.g.mapleader = " "

-- Conciseness
local keymap = vim.keymap

-- No <C-hjkl> pane navigation here. vim-tmux-navigator maps the same four keys
-- and loads after this file, so anything set here is silently overwritten --
-- and its versions cross into tmux panes, which `:wincmd` cannot do.

-- Windows
keymap.set("n", "<leader>wv", vim.cmd.vsplit, { desc = "Split Vertically" })
keymap.set("n", "<leader>ws", vim.cmd.split, { desc = "Split Horizontally" })
keymap.set("n", "<leader>we", "<C-w>=", { desc = "Equalize Splits" })
keymap.set("n", "<leader>wd", "<cmd>close<CR>", { desc = "Close Window" })

-- Quit
keymap.set("n", "<leader>qq", "<cmd>qa<CR>", { desc = "Quit All" })

-- External clipboard
keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to Clipboard" })
keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from Clipboard" })

-- Clearing the search highlight was the only thing <Esc> did not already do in
-- normal mode, and moving it here frees <leader>h for the git hunk group.
keymap.set(
  "n",
  "<Esc>",
  vim.cmd.nohlsearch,
  { desc = "Clear Search Highlight" }
)

-- Move whole lines. The destinations are deliberately asymmetric: moving down
-- measures from the end of the selection, moving up from its start. Using '>
-- for both makes the up-move a no-op on any selection longer than one line.
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move Selection Down" })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move Selection Up" })

-- Increment/Decrement numbers. <C-a> never reaches nvim -- it is the tmux
-- prefix (~/.tmux.conf) -- so this pair is the only way to reach it.
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment Number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement Number" })

-- Terminal. Opening one lives on <leader>ft / <C-/> in lua/plugins/snacks.lua;
-- this is just the way back out to normal mode.
keymap.set("t", "<C-x>", "<C-\\><C-n>", { desc = "Exit Terminal Mode" })
