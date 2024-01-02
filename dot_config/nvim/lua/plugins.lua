-- vi: ft=lua:ts=4:sw=4
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

require("lazy").setup{
    "vim-airline/vim-airline", -- bottom bar
    "vim-airline/vim-airline-themes", -- themes for bottom bar
    { "arcticicestudio/nord-vim", lazy = true }, -- nord theme for bar

    { "ms-jpq/coq_nvim", branch = "coq", build = "python3 -m coq deps" }, -- completion thing like vscode
    { "ms-jpq/coq.artifacts", branch = "artifacts" }, -- snippets for coq

    "tpope/vim-sensible", -- sensible settings
    "tpope/vim-fugitive", -- git wrapper
    "airblade/vim-gitgutter", -- show git status to left of line numbers

    { "junegunn/fzf", build = function() vim.fn["fzf#install"]() end }, -- fuzzy find

    "editorconfig/editorconfig-vim", -- support editorconfig in vim
    "mattn/emmet-vim", -- emmet; the html thingy
    "sheerun/vim-polyglot", -- file type pack for like a thousand different file types
    "andweeb/presence.nvim", -- discord presence
    -- { -- Disabled due to being a pain to use
    --    "kyazdani42/nvim-tree.lua", -- https://github.com/kyazdani42/nvim-tree.lua -- file explorer
    --    dependencies = {"kyazdani42/nvim-web-devicons" -- file icons
    --    }
    -- }

    "williamboman/mason.nvim", -- language server installer
    "williamboman/mason-lspconfig.nvim", -- integration between nvim-lspconfig and mason
    "neovim/nvim-lspconfig", -- make nvim use native lsp stuff
    "b0o/schemastore.nvim", -- https://github.com/b0o/SchemaStore.nvim -- json schemas
    "mfussenegger/nvim-dap", -- https://github.com/mfussenegger/nvim-dap --  Debug Adapter Protocol client implementation for Neovim

    {
        "folke/trouble.nvim",
        dependencies = {
            "folke/lsp-colors.nvim", -- https://github.com/folke/lsp-colors.nvim
            "kyazdani42/nvim-web-devicons" -- file icons
        }
    },

    'ellisonleao/gruvbox.nvim' -- Color theme -- https://github.com/ellisonleao/gruvbox.nvim
}
