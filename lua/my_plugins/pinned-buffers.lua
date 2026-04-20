local create_floating_window = require 'utils.create-floating-window'
local first_name_first = require('utils.filename-first')
local get_longest_name = require('utils.get-longest-string')
local save_load = require('utils.save-load')
local data_file = vim.fn.stdpath("data") .. "/pinned_buffers.json"

local M = {
    floating = {
        buf = -1,
        win = -1,
    },
    pinned_buffers = { "", "", "", "", "" }
}

local function close_floating_window()
    if vim.api.nvim_win_is_valid(M.floating.win) then
        vim.api.nvim_win_hide(M.floating.win)
    end
end

local function valdidate_buffer(index)
    local filepath = M.pinned_buffers[index]
    if filepath == nil or filepath == '' then
        return false
    end
    local stat = vim.loop.fs_stat(filepath)
    if stat and stat.type == 'file' then
        return true
    else
        M.pinned_buffers[index] = ''
        return false
    end
end

local function load_pinned_buffer(index)
    local bufferToLoad = M.pinned_buffers[index]
    if bufferToLoad == nil or bufferToLoad == '' then
        print("No pinned buffer at -> " .. index)
        return
    end
    local isValid = valdidate_buffer(index)
    if isValid == false then
        print("No pinned buffer at -> " .. index)
        return
    end
    close_floating_window()
    vim.cmd('edit ' .. vim.fn.fnameescape(bufferToLoad))
end

local function delete_pinned_buffer()
    local lineNumber, _ = unpack(vim.api.nvim_win_get_cursor(0))
    if lineNumber < 1 or lineNumber > 5 then
        return
    end
    M.pinned_buffers[lineNumber] = ''
    close_floating_window()
end

local function toggle_buffers_browser()
    if not vim.api.nvim_win_is_valid(M.floating.win) then
        for index, filepath in ipairs(M.pinned_buffers) do
            if filepath ~= '' then
                valdidate_buffer(index)
            end
        end

        local longest_name = get_longest_name(M.pinned_buffers) + 15

        M.floating = create_floating_window {
            buf = M.floating.buf,
            width = longest_name,
            height = 5,
            title = 'Pinned Buffers',
            style = ''
        }
        first_name_first(M.floating.buf, M.pinned_buffers)

        vim.keymap.set('n', '<esc>', close_floating_window, { buffer = M.floating.buf, nowait = true })
        vim.keymap.set('n', 'q', close_floating_window, { buffer = M.floating.buf, nowait = true })
        vim.keymap.set('n', '<M-e>', function()
            local lineNumber, _ = unpack(vim.api.nvim_win_get_cursor(0))
            load_pinned_buffer(lineNumber)
        end, { buffer = M.floating.buf, nowait = true })
        vim.keymap.set('n', 'd', ':DeletePinnedBuffer<CR>', { desc = 'Delete pinned buffer', silent = true, buffer = M.floating.buf })
        vim.keymap.set('n', '1', ':OpenPinnedBuffer 1<CR>', { desc = 'Open tagged buf at 1', silent = true, buffer = M.floating.buf })
        vim.keymap.set('n', '2', ':OpenPinnedBuffer 2<CR>', { desc = 'Open tagged buf at 2', silent = true, buffer = M.floating.buf })
        vim.keymap.set('n', '3', ':OpenPinnedBuffer 3<CR>', { desc = 'Open tagged buf at 3', silent = true, buffer = M.floating.buf })
        vim.keymap.set('n', '4', ':OpenPinnedBuffer 4<CR>', { desc = 'Open tagged buf at 4', silent = true, buffer = M.floating.buf })
        vim.keymap.set('n', '5', ':OpenPinnedBuffer 5<CR>', { desc = 'Open tagged buf at 5', silent = true, buffer = M.floating.buf })
    else
        vim.api.nvim_win_hide(M.floating.win)
    end
end

local function pin_buffer(index)
    if index < 1 or index > 5 then return end
    local current = vim.api.nvim_get_current_buf()
    local bufName = vim.api.nvim_buf_get_name(current)
    if bufName == nil or bufName == '' then return end
    M.pinned_buffers[index] = bufName
end

local function save_pinned_buffers()
    save_load.save(data_file, M.pinned_buffers)
end

local function set_auto_commands()
    vim.api.nvim_create_autocmd('VimLeavePre', {
        callback = save_pinned_buffers,
    })
end

local function set_commands()
    vim.api.nvim_create_user_command('TogglePinnedBuffersBrowser', toggle_buffers_browser, {})
    vim.api.nvim_create_user_command('DeletePinnedBuffer', delete_pinned_buffer, {})
    vim.api.nvim_create_user_command('SetPinnedBuffer', function(opts)
        local buf_index = tonumber(opts.args)
        pin_buffer(buf_index)
    end, { nargs = 1 })
    vim.api.nvim_create_user_command('OpenPinnedBuffer', function(opts)
        local buf_index = tonumber(opts.args)
        load_pinned_buffer(buf_index)
    end, { nargs = 1 })
end

local function set_keymaps()
    vim.keymap.set('n', '<leader>b', ':TogglePinnedBuffersBrowser<CR>',
        { desc = 'Toggle taged buffers browser', silent = true })
    vim.keymap.set('n', '<leader>1', ':OpenPinnedBuffer 1<CR>', { desc = 'Open tagged buf at 1', silent = true })
    vim.keymap.set('n', '<leader>2', ':OpenPinnedBuffer 2<CR>', { desc = 'Open tagged buf at 2', silent = true })
    vim.keymap.set('n', '<leader>3', ':OpenPinnedBuffer 3<CR>', { desc = 'Open tagged buf at 3', silent = true })
    vim.keymap.set('n', '<leader>4', ':OpenPinnedBuffer 4<CR>', { desc = 'Open tagged buf at 4', silent = true })
    vim.keymap.set('n', '<leader>5', ':OpenPinnedBuffer 5<CR>', { desc = 'Open tagged buf at 5', silent = true })
    vim.keymap.set('n', '<M-1>', ':SetPinnedBuffer 1<CR>', { desc = 'Set tagged buf at 1', silent = true })
    vim.keymap.set('n', '<M-2>', ':SetPinnedBuffer 2<CR>', { desc = 'Set tagged buf at 2', silent = true })
    vim.keymap.set('n', '<M-3>', ':SetPinnedBuffer 3<CR>', { desc = 'Set tagged buf at 3', silent = true })
    vim.keymap.set('n', '<M-4>', ':SetPinnedBuffer 4<CR>', { desc = 'Set tagged buf at 4', silent = true })
    vim.keymap.set('n', '<M-5>', ':SetPinnedBuffer 5<CR>', { desc = 'Set tagged buf at 5', silent = true })
end

M.setup = function()
    M.floating.buf = vim.api.nvim_create_buf(false, true)
    local saved_buffers = save_load.load(data_file)
    if saved_buffers ~= {} then
        M.pinned_buffers = saved_buffers
    end
    set_auto_commands()
    set_commands()
    set_keymaps()
end

return M
