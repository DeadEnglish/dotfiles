-- Set leader key to space
vim.g.mapleader = " "
-- Indent settings
vim.opt.autoindent = true
vim.opt.smartindent = true
-- Tab settings
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
-- Disable swap files
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- visual lines and numbering
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.number = true
vim.opt.numberwidth = 2
vim.opt.relativenumber = true

-- Spelling
vim.opt.spelllang = "en_gb"
vim.opt.spell = true
