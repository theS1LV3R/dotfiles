call plug#begin(expand('~/.config/nvim/plugged'))

" Plug 'itchyny/lightline.vim', {'colorscheme': 'nord'}

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-sensible'
Plug 'arcticicestudio/nord-vim'
Plug 'airblade/vim-gitgutter'

call plug#end()

let g:airline_powerline_fonts = 1

colorscheme nord

set number
set linebreak
set showbreak=+++
set textwidth=100
set showmatch

set hlsearch
set smartcase
set ignorecase
set incsearch

set autoindent
set expandtab
set shiftwidth=2
set smartindent
set smarttab
set softtabstop=2

set ruler
set noshowmode

set undolevels=1000
set backspace=indent,eol,start

filetype plugin on
syntax on
