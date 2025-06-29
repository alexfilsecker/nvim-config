-- Lazy set up file

-- Ensure lazy is installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Use lazy
require("lazy").setup(
  { { import = "alex.plugins" }, { import = "alex.plugins.lsp" } },
  {
    checker = {
      -- Used to check for updates
      enabled = true,
      notify = false,
    },
    change_detection = {
      notify = false, -- Disable annoying notifications whenever a plugin file changes
    },
  }
)
