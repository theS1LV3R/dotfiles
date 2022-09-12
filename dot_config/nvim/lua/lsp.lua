-- vi: ft=lua:ts=4:sw=4
-- language server installer
require("mason").setup({
    ui = {
        border = "rounded"
    }
})

vim.g.coq_settings = {
    display = {
        icons = {
            mode = "short"
        }
    },
    auto_start = true,
    xdg = true
}

local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
lsp_capabilities.textDocument.completion.completionItem.snippetSupport = true

local json_schemas = require('schemastore').json.schemas {}
local yaml_schemas = {}

vim.tbl_map(function(schema)
    yaml_schemas[schema.url] = schema.fileMatch
end, json_schemas)

local common_opts = {
    autostart = true,
    capabilities = lsp_capabilities
}

local function merge_common(tbl)
    for k, v in pairs(common_opts) do
        tbl[k] = v
    end
    return tbl
end

local coq = require("coq")

require("mason-lspconfig").setup()
require("mason-lspconfig").setup_handlers {
    function(server_name)
        require("lspconfig")[server_name].setup(coq.lsp_ensure_capabilities(common_opts))
    end,

    ["jsonls"] = function()
        require('lspconfig')["jsonls"].setup(coq.lsp_ensure_capabilities(merge_common {
            settings = {
                json = {
                    schemas = json_schemas,
                    validate = {
                        enable = true
                    }
                }
            }
        }))
    end,

    ["yamlls"] = function()
        require("lspconfig")["yamlls"].setup(coq.lsp_ensure_capabilities(merge_common {
            settings = {
                yaml = {
                    schemas = yaml_schemas,
                    validate = true
                }
            }
        }))
    end
}
