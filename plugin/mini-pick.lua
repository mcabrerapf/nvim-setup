local gh = require("utils.gh")
vim.pack.add({ gh("nvim-mini/mini.pick") })
local filename_first = require 'utils.filename-first'

local mini_pick = require('mini.pick')

local function win_config()
    local height = math.floor(0.35 * vim.o.lines)
    local width = math.floor(0.75 * vim.o.columns)

    local config = {
        anchor = 'NE',
        height = height,
        width = width,
        border = 'rounded',
        row = math.floor(0.55 * vim.o.lines),
        col = math.floor(0.88 * vim.o.columns),
    }
    return config
end

mini_pick.setup({
    window = {
        config = win_config,
    },
    mappings = {
        -- toggle_info    = '<C-k>',
        -- toggle_preview = '<C-p>',
        -- scroll_right = '<C-l>',
        stop = '<M-q>',
        choose = '<M-l>',
        choose_in_vsplit = '<M-v>',
        move_down = '<M-j>',
        move_up = '<M-k>',
        mark = '<M-x>',
        choose_marked = '<M-n>',
    },
})

local function open_mini_pick()
    mini_pick.builtin.files(nil, {
        source = {
            name = 'Search files',
            show = filename_first,
        },
    })
end

local function open_mini_pick_grep()
    mini_pick.builtin.grep_live(nil, {
        source = {
            name = 'Grep search',
        },
    })
end

local function grep_word_on_cursor()
    local cword = vim.fn.expand("<cword>")
    mini_pick.builtin.grep({ pattern = cword }, { source = { name = cword } })
end

local function grep_selection()
    vim.cmd("normal! y")
    local text = vim.fn.getreg('"')
    mini_pick.builtin.grep({ pattern = text }, { source = { name = text } })
end

local function search_nvim_config()
    mini_pick.builtin.files(nil, {
        source = {
            name = 'Search nvim files',
            cwd = vim.fn.stdpath 'config',
            show = filename_first,
        },
    })
end
-- Keymaps
vim.keymap.set('n', '<leader>ss', open_mini_pick, { desc = 'Search files' })
vim.keymap.set('n', '<leader>sS', open_mini_pick_grep, { desc = 'Do grep search' })
vim.keymap.set('n', '<leader>sw', grep_word_on_cursor, { desc = "Grep word" })
vim.keymap.set('v', '<leader>s', grep_selection, { desc = "Grep selection" })
vim.keymap.set('n', '<leader>sv', search_nvim_config, { desc = 'Search files in nvim config' })
vim.keymap.set('n', '<leader>sb', mini_pick.builtin.buffers, { desc = 'Search in buffers' })
vim.keymap.set('n', '<leader>sh', mini_pick.builtin.help, { desc = 'Search help tags' })
vim.keymap.set('n', '<leader>sr', mini_pick.builtin.resume, { desc = 'Resume last search' })
