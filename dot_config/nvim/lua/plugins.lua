-- vi: ft=lua shiftwidth=4 tabstop=4
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
                                  install_path})
    vim.cmd [[packadd packer.nvim]]
end

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use 'vim-airline/vim-airline'
    use 'vim-airline/vim-airline-themes'
    use 'arcticicestudio/nord-vim'

    use {
        'neoclide/coc.nvim',
        branch = 'release'
    }
    use 'tpope/vim-sensible'
    use 'tpope/vim-fugitive'
    use 'airblade/vim-gitgutter'

    use {
        'junegunn/fzf',
        run = function()
            vim.fn['fzf#install']()
        end
    }

    use 'editorconfig/editorconfig-vim'
    use 'mattn/emmet-vim'
    use 'pechorin/any-jump.vim'
    use 'sheerun/vim-polyglot'
    use 'skanehira/docker-compose.vim'
    use 'andweeb/presence.nvim'
    use {
        'kyazdani42/nvim-tree.lua', -- https://github.com/kyazdani42/nvim-tree.lua
        requires = {'kyazdani42/nvim-web-devicons' -- file icons
        }
    }

    use 'neovim/nvim-lspconfig'

    if packer_bootstrap then
        require("packer").sync()
    end
end)
