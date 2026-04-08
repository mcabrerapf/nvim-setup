local keymap = require('utils.keymap')
vim.lsp.enable('lua_ls')
vim.lsp.enable('gdscript')
vim.lsp.enable('gdshader')

vim.keymap.del({ "n", "v" }, "gra")
vim.keymap.del("n", "gri")
vim.keymap.del("n", "grn")
vim.keymap.del("n", "grr")
vim.keymap.del("n", "grt")
vim.keymap.del("n", "grx")

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        local lspkeymap = function(method_to_check, lhs, rhs, desc)
            if client == nil then return end
            if client:supports_method(method_to_check) then
                keymap(lhs, rhs, desc, event.buf)
            end
        end
        if client and client:supports_method('textDocument/documentHighlight', event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
                group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
                callback = function(event2)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
                end,
            })
        end

        lspkeymap('textDocument/codeAction', 'gra', vim.lsp.buf.code_action, "Go to code action")
        lspkeymap('textDocument/declaration', 'grd', vim.lsp.buf.declaration, "Go to declaration")
        lspkeymap('textDocument/definition', 'grD', vim.lsp.buf.definition, "Go to definition")
        lspkeymap('textDocument/formatting', 'grf', vim.lsp.buf.format, "Format")
        lspkeymap('textDocument/inlayHint', 'grh', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end, "Toggle lsp inlay hints")
        lspkeymap('textDocument/implementation', 'gri', vim.lsp.buf.implementation, "Go to implementation")
        lspkeymap('textDocument/rename', 'grn', vim.lsp.buf.rename, "Rename")
        lspkeymap('textDocument/documentSymbol', 'gro', vim.lsp.buf.document_symbol, "Document symbols")
        lspkeymap('textDocument/references', 'grr', vim.lsp.buf.references, "References")
        lspkeymap('textDocument/typeDefinition', 'grt', vim.lsp.buf.type_definition, "Go to type definition")
        lspkeymap('textDocument/codeLens', 'grx', vim.lsp.codelens.run, "Run codelens")
    end,
})
