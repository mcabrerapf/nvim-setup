local gh = require("utils.gh")
vim.pack.add({ gh("nvim-treesitter/nvim-treesitter-textobjects") })
vim.g.no_plugin_maps = true

local textobjects = require('nvim-treesitter-textobjects')
textobjects.setup({
    move = { enable = true },
    select = {
        enable = true,
        lookahead = true,
        selection_modes = {
            ['@parameter.outer'] = 'v', -- charwise
            ['@function.outer'] = 'V', -- linewise
            ['@class.outer'] = '<c-v>', -- blockwise
        },
        keymaps = {
            ['af'] = '@body.outer',
            ['if'] = '@body.inner',
        },
        include_surrounding_whitespace = false,
    },
})

local textobjectsSelect = require('nvim-treesitter-textobjects.select')
local textobjectsMove = require('nvim-treesitter-textobjects.move')
-- Class
vim.keymap.set({ "x", "o" }, "ic", function()
    textobjectsSelect.select_textobject("@class.inner", "textobjects")
end, { desc = 'class' })
vim.keymap.set({ "x", "o" }, "ac", function()
    textobjectsSelect.select_textobject("@class.outer", "textobjects")
end, { desc = 'class' })
-- Function
vim.keymap.set({ 'x', 'o' }, 'if', function()
    textobjectsSelect.select_textobject('@function.inner', 'textobjects')
end, { desc = 'function' })
vim.keymap.set({ 'x', 'o' }, 'af', function()
    textobjectsSelect.select_textobject('@function.outer', 'textobjects')
end, { desc = 'function' })
vim.keymap.set({ 'n', 'x', 'o' }, '[f', function()
    textobjectsMove.goto_previous_start("@function.outer", "textobjects")
end, { desc = 'function' })
vim.keymap.set({ 'n', 'x', 'o' }, ']f', function()
    textobjectsMove.goto_next_start("@function.outer", "textobjects")
end, { desc = 'function' })
-- Loop
vim.keymap.set({ 'x', 'o' }, 'il', function()
    textobjectsSelect.select_textobject('@loop.inner', 'textobjects')
end, { desc = 'loop' })
vim.keymap.set({ 'x', 'o' }, 'al', function()
    textobjectsSelect.select_textobject('@loop.outer', 'textobjects')
end, { desc = 'loop' })
-- If
vim.keymap.set({ 'x', 'o' }, 'ii', function()
    textobjectsSelect.select_textobject('@conditional.inner', 'textobjects')
end, { desc = 'if' })
vim.keymap.set({ 'x', 'o' }, 'ai', function()
    textobjectsSelect.select_textobject('@conditional.outer', 'textobjects')
end, { desc = 'if' })
-- Parameter
vim.keymap.set({ "x", "o" }, "ia", function()
    textobjectsSelect.select_textobject("@parameter.inner", "textobjects")
end, { desc = 'argument' })
vim.keymap.set({ "x", "o" }, "aa", function()
    textobjectsSelect.select_textobject("@parameter.outer", "textobjects")
end, { desc = 'argument' })
vim.keymap.set({ 'n', 'x', 'o' }, '[a', function()
    textobjectsMove.goto_previous_start("@parameter.inner", "textobjects")
end, { desc = 'argument' })
vim.keymap.set({ 'n', 'x', 'o' }, ']a', function()
    textobjectsMove.goto_next_start("@parameter.inner", "textobjects")
end, { desc = 'argument' })
