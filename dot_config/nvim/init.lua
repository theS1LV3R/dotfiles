require("plugins")
require("plug-configs")

vim.g.airline_powerline_fonts = 1

vim.cmd([[
colorscheme nord
]])

vim.opt.number = true
vim.opt.linebreak = true
vim.opt.showbreak = '+++'
vim.opt.textwidth = 100
vim.opt.showmatch = true

vim.opt.hlsearch = true
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.incsearch = true

vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.softtabstop = 2
vim.opt.mouse = a

vim.opt.ruler = true
vim.opt.showmode = false

vim.opt.undolevels = 1000
vim.opt.backspace = 'indent,eol,start'

vim.cmd([[
filetype plugin on
syntax on

au VimLeave * set guicursor=a:ver100-blinkon1
]])
