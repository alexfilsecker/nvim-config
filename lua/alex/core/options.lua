-- Use tree style file explorer
vim.cmd("let g:netrw_liststyle = 3")

-- Consiceness
local opt = vim.opt

-- Autoread
opt.autoread = true -- Reload a file when it changes outside of the buffer
vim.api.nvim_create_autocmd(
  { "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" },
  {
    command = "if mode() != 'c' | checktime | endif",
    pattern = { "*" },
  }
)

-- tabs & indents
opt.autoindent = true -- Copy indentation from current line when starting new one
opt.expandtab = true -- Transform tabs into spaces
opt.tabstop = 2 -- Tabs use 2 spaces
opt.softtabstop = 2 -- For editor purposes, does not change the file
opt.shiftwidth = 2 -- For tabing with >> or <

-- line numbers
opt.number = true -- To show actual line number in left column
opt.relativenumber = true -- To show relative numbers in right column

-- colors
opt.termguicolors = true -- To use true colors
opt.signcolumn = "yes" -- So that numbers dont shift widely

-- Window Spliting
opt.splitright = true -- Split vertical window to the right
opt.splitbelow = true -- Split horizontal window to the bottom

-- backspace
opt.backspace = "indent,eol,start" -- Use intuitive backspace

-- Searching
opt.hlsearch = true -- Highlight what you have searched for
opt.incsearch = true -- Search as you type
opt.ignorecase = true -- Ignore case when searching
opt.smartcase = true -- If you include mixed case, it uses that

-- Scrolling
opt.scrolloff = 8 -- Min number of lines to show when available

-- Wraping
opt.wrap = false -- Disables line wraping
opt.linebreak = false -- Disable line breaking when wraping

-- Cursor line
opt.cursorline = true -- Sets the cursorline to appear

-- Recovery
opt.swapfile = false -- No swap file
opt.backup = false -- No backups
vim.undofile = true -- Undo history saving
vim.undodir = os.getenv("HOME") .. "/.vim/undodir" -- Path to save undoes
