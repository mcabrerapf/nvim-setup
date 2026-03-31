vim.pack.add({"https://github.com/nvim-mini/mini.files"})

local files = require('mini.files')
files.setup({
    git_status = true,
    mappings = {
        close = 'q',
        go_in = 'l',
        go_in_plus = '<M-l>',
        go_out = 'h',
        go_out_plus = 'H',
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
-- Auto Commands
local group = vim.api.nvim_create_augroup('MiniFilesHooks', { clear = true })
vim.api.nvim_create_autocmd('User', {
    group = group,
    pattern = 'MiniFilesExplorerOpen',
    callback = function()
        -- Key maps
        vim.keymap.set('n', '<M-e>', function()
            local fs = require 'mini.files'
            local entry = fs.get_fs_entry()
            if not entry then
                return
            end
            local path = entry.path
            if entry.fs_type == 'file' then
                path = vim.fs.dirname(path)
            end
            vim.cmd('tcd ' .. path)
            print('Pwd set to -> ' .. path)
        end, { desc = 'Set dir as pwd' })
        --
        vim.keymap.set('n', '<M-s>', function()
            local fs = require 'mini.files'
            local entry = fs.get_fs_entry()
            if not entry or entry.fs_type == 'file' then
                return
            end
            fs.close()
            local pick = require 'mini.pick'
            local path = entry.path
            pick.builtin.files(nil, { source = { cwd = path, name = 'Search files' } })
        end, { desc = '[s]earch files in folder' })
        --
        vim.keymap.set('n', '<M-s><M-s>', function()
            local fs = require 'mini.files'
            local entry = fs.get_fs_entry()
            if not entry or entry.fs_type == 'file' then
                return
            end
            fs.close()
            local pick = require 'mini.pick'
            local path = entry.path
            pick.builtin.grep_live(nil, { source = { cwd = path, name = 'Grep search' } })
        end, { desc = 'Grep [S]earch in folder' })
    end,
})
vim.api.nvim_create_autocmd('User', {
    group = group,
    pattern = 'MiniFilesExplorerClose',
    callback = function()
        vim.keymap.del('n', '<M-e>', {})
        vim.keymap.del('n', '<M-s>', {})
        vim.keymap.del('n', '<M-s><M-s>', {})
    end,
})
-- Key Mappings
vim.keymap.set('n', '<leader>ff', function()
    files.open(vim.api.nvim_buf_get_name(0), false)
end, { desc = '[f]ile explorer (current file)' })

vim.keymap.set('n', '<leader>fF', function()
    files.open(vim.uv.cwd(), true)
end, { desc = '[F]ile [e]xplorer' })

vim.keymap.set('n', '<leader>fvc', function()
    files.open(vim.fn.stdpath 'config', false)
end, { desc = 'Open Neovim [c]onfig directory' })

vim.keymap.set('n', '<leader>fvp', function()
    files.open(vim.fn.stdpath 'config' .. '/lua/plugins', false)
end, { desc = 'Open Neovim config [p]lugins dir' })
