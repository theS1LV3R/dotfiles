return {{
    "L3MON4D3/LuaSnip",
    version = "v4.*",
    build = "make install_jsregexp",
    init = function()
        require("luasnip.loaders.from_lua").load({
            paths = "~/.config/nvim/LuaSnip/"
        })
    end
}}
