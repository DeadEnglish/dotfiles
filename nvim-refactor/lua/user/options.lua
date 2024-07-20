-- Set leader key to space
vim.g.mapleader = " "

-- Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Complete option experience
vim.opt.completeopt = { "menuone", "noselect" }
-- Splitting
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Indentation
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.breakindent = true

-- Tabbing
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

-- Disable swap files for undov
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Show cursor line highlight
vim.opt.cursorline = true

-- buffer line options
vim.opt.scrolloff = 8
vim.opt.number = true
vim.opt.numberwidth = 2
vim.opt.relativenumber = true

-- Options for nvim ufo
vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Enable 24bit colours
vim.opt.termguicolors = true

-- Always show signcolumns
vim.opt.signcolumn = "yes"

-- enable copy to global clipboard
vim.opt.clipboard = "unnamed,unnamedplus"
