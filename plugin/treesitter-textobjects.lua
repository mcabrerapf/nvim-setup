vim.pack.add({"https://github.com/nvim-treesitter/nvim-treesitter-textobjects"})

vim.g.no_plugin_maps = true

local textobjects = require('nvim-treesitter-textobjects')
local textobjectselect = require('nvim-treesitter-textobjects.select')
textobjects.setup({
    move = { enable = true },
    select = {
        -- Automatically jump forward to textobj, similar to targets.vim
        enable = true,
        lookahead = true,
        selection_modes = {
            ['@parameter.outer'] = 'v', -- charwise
            ['@function.outer'] = 'V', -- linewise
            -- ['@class.outer'] = '<c-v>', -- blockwise
        },
        keymaps = {
            ['af'] = '@body.outer',
            ['if'] = '@body.inner',
        },
        -- If you set this to `true` (default is `false`) then any textobject is
        -- extended to include preceding or succeeding whitespace. Succeeding
        -- whitespace has priority in order to act similarly to eg the built-in
        -- `ap`.
        --
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * selection_mode: eg 'v'
        -- and should return true of false
        include_surrounding_whitespace = false,
    },
})


vim.keymap.set({ 'x', 'o' }, 'im', function()
    textobjectselect.select_textobject('@function.inner', 'textobjects')
end, { desc = 'function' })
vim.keymap.set({ 'x', 'o' }, 'am', function()
    textobjectselect.select_textobject('@function.outer', 'textobjects')
end, { desc = 'function' })
vim.keymap.set({ 'x', 'o' }, 'if', function()
    textobjectselect.select_textobject('@loop.inner', 'textobjects')
end, { desc = 'loop' })
vim.keymap.set({ 'x', 'o' }, 'af', function()
    textobjectselect.select_textobject('@loop.outer', 'textobjects')
end, { desc = 'loop' })
vim.keymap.set({ 'x', 'o' }, 'ii', function()
    textobjectselect.select_textobject('@conditional.inner', 'textobjects')
end, { desc = 'if' })
vim.keymap.set({ 'x', 'o' }, 'ai', function()
    textobjectselect.select_textobject('@conditional.outer', 'textobjects')
end, { desc = 'if' })
