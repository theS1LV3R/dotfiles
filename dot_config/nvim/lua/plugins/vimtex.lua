return {{
    "lervag/vimtex",
    lazy = false,
    init = function()
        vim.g.vimtex_view_method = 'zathura_simple' -- Use simple version of zathura pdf viewer (see :help vimtex-view-zathura-simple)
    end
}}
