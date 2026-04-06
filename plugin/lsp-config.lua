local gh = require("utils.gh")
vim.pack.add({ gh("mason-org/mason.nvim") })
vim.pack.add({ gh("mason-org/mason-lspconfig.nvim") })
vim.pack.add({ gh("WhoIsSethDaniel/mason-tool-installer.nvim") })
require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = {
        'lua_ls',
        'ts_ls'
    }
})
vim.pack.add({ gh("neovim/nvim-lspconfig") })
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
    callback = function(event)
        local keymap = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        keymap('grn', vim.lsp.buf.rename, 'Rename')
        keymap('gra', vim.lsp.buf.code_action, 'Go to code action', { 'n', 'x' })
        keymap('grD', vim.lsp.buf.declaration, 'Go to declaration')

        local client = vim.lsp.get_client_by_id(event.data.client_id)
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

        if client and client:supports_method('textDocument/inlayHint', event.buf) then
            keymap('<leader>th', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, 'Toggle inline hints')
        end
    end,
})


local capabilities = require('blink.cmp').get_lsp_capabilities()
local servers = {
    ts_ls = {},
    -- gdscript = {},
    -- gdshader ={},
    -- godot_resource ={},
    -- html = {},
    lua_ls = {},
    -- ts_ls = {},
}

local ensure_installed = vim.tbl_keys(servers or {})
require('mason-tool-installer').setup { ensure_installed = ensure_installed }

for name, server in pairs(servers) do
    server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
    vim.lsp.config(name, server)
    vim.lsp.enable(name)
end

vim.lsp.config('lua_ls', {
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
            return
            end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
            version = 'LuaJIT',
            path = { 'lua/?.lua', 'lua/?/init.lua' },
            },
            workspace = {
            checkThirdParty = false,
            -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
            --  See https://github.com/neovim/nvim-lspconfig/issues/3189
            library = vim.api.nvim_get_runtime_file('', true),
            },
        })
    end,
    settings = {
        Lua = {},
    },
})

vim.lsp.enable 'lua_ls'
-- Godot bits
vim.lsp.config('gdscript', { capabilities = capabilities })
vim.lsp.enable 'gdscript'

vim.lsp.config('gdshader', { capabilities = capabilities })
vim.lsp.enable 'gdshader'

vim.lsp.config('godot_resource', { capabilities = capabilities })
vim.lsp.enable 'godot_resource'
