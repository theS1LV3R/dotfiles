-- vi: ft=lua:ts=4:sw=4
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim",
                                  install_path})
    vim.cmd [[packadd packer.nvim]]
end

return require("packer").startup(function(use)
    use "wbthomason/packer.nvim" -- plugin manager

    use "vim-airline/vim-airline" -- bottom bar
    use "vim-airline/vim-airline-themes" -- themes for bottom bar
    use "arcticicestudio/nord-vim" -- nord theme for bar

    use {
        "ms-jpq/coq_nvim", -- completion thing like vscode
        branch = "coq",
        run = "python3 -m coq deps"
    }
    use {
        "ms-jpq/coq.artifacts", -- snippets for coq
        branch = "artifacts"
    }

    use "tpope/vim-sensible" -- sensible settings
    use "tpope/vim-fugitive" -- git wrapper
    use "airblade/vim-gitgutter" -- show git status to left of line numbers

    use {
        "junegunn/fzf", -- fuzzy find
        run = function()
            fn["fzf#install"]()
        end
    }

    use "editorconfig/editorconfig-vim" -- support editorconfig in vim
    use "mattn/emmet-vim" -- emmet; the html thingy
    use "sheerun/vim-polyglot" -- file type pack for like a thousand different file types
    use "andweeb/presence.nvim" -- discord presence
--    use { -- Disabled due to being a pain to use
--        "kyazdani42/nvim-tree.lua", -- https://github.com/kyazdani42/nvim-tree.lua -- file explorer
--        requires = {"kyazdani42/nvim-web-devicons" -- file icons
--        }
--    }

    use "williamboman/mason.nvim" -- language server installer
    use "williamboman/mason-lspconfig.nvim" -- integration between nvim-lspconfig and mason
    use "neovim/nvim-lspconfig" -- make nvim use native lsp stuff
    use "b0o/schemastore.nvim" -- https://github.com/b0o/SchemaStore.nvim -- json schemas
    use 'mfussenegger/nvim-dap' -- https://github.com/mfussenegger/nvim-dap --  Debug Adapter Protocol client implementation for Neovim

    use {
        "folke/trouble.nvim",
        requires = {"folke/lsp-colors.nvim", -- https://github.com/folke/lsp-colors.nvim
        "kyazdani42/nvim-web-devicons" -- file icons
        }
    }

    if packer_bootstrap then
        require("packer").sync()
    end
end)
