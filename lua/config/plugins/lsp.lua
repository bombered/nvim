return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            'saghen/blink.cmp',
        },
        config = function()
            local capabilities = require('blink.cmp').get_lsp_capabilities()
            vim.lsp.config('lua_ls', { capabilites = capabilities })
            vim.lsp.config('clangd', { capabilites = capabilities })

            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(args)
                    local c = assert(vim.lsp.get_client_by_id(args.data.client_id))
                    if not c then return end
                    -- Auto-format ("lint") on save.
                    -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
                    if not c:supports_method('textDocument/willSaveWaitUntil')
                        and c:supports_method('textDocument/formatting') then
                        vim.api.nvim_create_autocmd('BufWritePre', {
                            buffer = args.buf,
                            callback = function()
                                vim.lsp.buf.format({ bufnr = args.buf, id = c.id, timeout_ms = 1000 })
                            end,
                        })
                    end
                end,
            })
        end,
    }
}
