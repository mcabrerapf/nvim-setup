local gh = require("utils.gh")
vim.pack.add({ gh("MeanderingProgrammer/render-markdown.nvim") })
require('render-markdown').setup({
    file_types = { 'markdown', 'vimwiki', 'text' },
    completions = {
        blink = { enabled = false },
        lsp = { enabled = true }
    },
})
