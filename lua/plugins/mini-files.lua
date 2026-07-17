local gh = require("utils.gh")
vim.pack.add({ gh("nvim-mini/mini.files") })
local mini_files = require('mini.files')
mini_files.setup({
    git_status = true,
    mappings = {
        close = 'q',
        go_in = 'l',
        go_in_plus = '<M-l>',
        -- go_out = 'h',
        go_out_plus = 'h',
        mark_goto = "'",
        mark_set = 'm',
        reset = '<BS>',
        reveal_cwd = '.',
        show_help = 'g?',
        synchronize = '=',
        trim_left = '<',
        trim_right = '>',
    },
    windows = {
        preview = true,
        width_focus = 30,
        width_nofocus = 15,
        width_preview = 45,
    },
    icons = {
        git = {
            added = '',
            modified = '柳',
            removed = '',
            renamed = '➜',
            untracked = '★',
            ignored = '◌',
        },
    },
})

local function base_filter(fs_entry)
    return not vim.endswith(fs_entry.name, '.uid') and not vim.endswith(fs_entry.name, '.tmp')
end

local function open_mini_files()
    mini_files.open(nil, false, { content = { filter = base_filter } })
end

local function open_in_file()
    mini_files.open(vim.api.nvim_buf_get_name(0), false, { content = { filter = base_filter } })
end

local function open_nvim_config()
    mini_files.open(vim.fn.stdpath 'config', false)
end

local function set_as_cwd()
    local fs = require 'mini.files'
    local entry = fs.get_fs_entry()
    if not entry then return end
    local path = entry.path
    if entry.fs_type == 'file' then
        path = vim.fs.dirname(path)
    end
    vim.cmd('tcd ' .. path)
    print('cwd set to -> ' .. path)
end

local function open_mini_pick()
    local fs = require 'mini.files'
    local entry = fs.get_fs_entry()
    if not entry or entry.fs_type == 'file' then return end
    fs.close()
    local pick = require 'mini.pick'
    local path = entry.path
    pick.builtin.files(nil, { source = { cwd = path, name = 'Search files in ' .. path } })
end

local function open_mini_pick_grep()
    local fs = require 'mini.files'
    local entry = fs.get_fs_entry()
    if not entry or entry.fs_type == 'file' then return end
    fs.close()
    local pick = require 'mini.pick'
    local path = entry.path
    pick.builtin.grep_live(nil, { source = { cwd = path, name = 'Grep search in ' .. path } })
end

local ui_open = function() vim.ui.open(mini_files.get_fs_entry().path) end

local group = vim.api.nvim_create_augroup('MiniFilesHooks', { clear = true })
vim.api.nvim_create_autocmd('User', {
    group = group,
    pattern = 'MiniFilesBufferCreate',
    callback = function(event)
        -- Key maps
        local buf_id = event.data.buf_id
        vim.keymap.set('n', '<M-e>', set_as_cwd, { buf = buf_id, desc = 'Set dir as cwd' })
        vim.keymap.set('n', '<M-s>', open_mini_pick, { buf = buf_id, desc = 'Search in folder' })
        vim.keymap.set('n', '<M-S>', open_mini_pick_grep, { buffer = buf_id, desc = 'Grep search in folder' })
        vim.keymap.set('n', '<M-o>', ui_open, { buffer = buf_id, desc = 'Open with os' })
    end,
})
-- Key Mappings
vim.keymap.set('n', '<leader>ff', open_in_file, { desc = 'File explorer' })
vim.keymap.set('n', '<leader>fF', open_mini_files, { desc = 'File explorer (in pwd)' })
vim.keymap.set('n', '<leader>fv', open_nvim_config, { desc = 'Open Neovim config directory' })
