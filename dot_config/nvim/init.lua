-- vi: ft=lua:ts=4:sw=4
require("plugins")
require("plug-configs")
require("lsp")

vim.g.airline_powerline_fonts = 1
vim.g.airline_theme = 'base16_gruvbox_dark_pale'

vim.opt.background = 'dark'
vim.cmd [[colorscheme gruvbox]]

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
vim.opt.mouse = 'a'

vim.opt.ruler = true
vim.opt.showmode = false

vim.opt.undolevels = 1000
vim.opt.backspace = 'indent,eol,start'

vim.api.nvim_set_keymap('n', '<C-t>', ':NvimTreeFocus<CR>', {
    noremap = true,
    silent = true
})
vim.api.nvim_set_keymap('n', '<C-d>', ':qa<CR>', {
    noremap = true,
    silent = false
})

vim.cmd([[
filetype plugin on
syntax on

au VimLeave * set guicursor=a:ver100-blinkon1
]])
