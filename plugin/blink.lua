local gh = require("utils.gh")
vim.pack.add({
    {
        src = gh("saghen/blink.cmp"),
        version = vim.version.range("1.x")
    }
})
require("blink.cmp").setup({
    signature = { enabled = true },
    cmdline = {
        keymap = {
            ['<M-h>'] = { 'cancel' },
            ['<M-j>'] = { 'select_next', 'fallback' },
            ['<M-k>'] = { 'select_prev', 'fallback' },
            ['<M-l>'] = { 'select_and_accept' },
            ['<M-n>'] = { 'show_documentation', 'hide_documentation' },
            ['<M-m>'] = { 'show_signature', 'hide_signature' },
            ['<C-n>'] = false,
            ['<C-p>'] = false,
        },
    },
    keymap = {
        ['<M-h>'] = { 'cancel' },
        ['<M-j>'] = { 'select_next', 'fallback' },
        ['<M-k>'] = { 'select_prev', 'fallback' },
        ['<M-l>'] = { 'select_and_accept' },
        ['<M-n>'] = { 'show_documentation', 'hide_documentation' },
        ['<M-m>'] = { 'show_signature', 'hide_signature' },
        ['<C-n>'] = false,
        ['<C-p>'] = false,
        ['<M-q>'] = { 'cancel' },
    },
    completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        -- sources = {
        --     default = {
        --         "lsp", "path", "snippets"
        --     }
        -- },
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
    },
    -- snippets = {
    --   preset = "luasnip"
    -- },
    sources = {
        default = { 'lsp', 'snippets', 'path', 'buffer' },
    },
    -- See :h blink-cmp-config-fuzzy for more information
    fuzzy = { implementation = 'lua' },
})
