local create_floating_window = require 'utils.create-floating-window'
local first_name_first = require('utils.filename-first')
local get_longest_name = require('utils.get-longest-string')
local save_load = require('utils.save-load')
local data_file = vim.fn.stdpath("data") .. "/pinned_files.json"

local M = {
    win = -1,
    buf = -1,
    pinned_files = { "", "", "", "", "" }
}

local function close_floating_window()
    if vim.api.nvim_win_is_valid(M.win) then
        vim.api.nvim_win_hide(M.win)
    end
end

local function populate_buf()
    vim.bo[M.buf].modifiable = true
    first_name_first(M.buf, M.pinned_files)
    vim.bo[M.buf].modifiable = false
end

local function valdidate_file(index)
    local filepath = M.pinned_files[index] or ''
    local isValid
    if filepath == '' then
        isValid =  false
    end
    local stat = vim.loop.fs_stat(filepath)
    if stat and stat.type == 'file' then
        isValid = true
    else
        M.pinned_files[index] = ''
        isValid =  false
    end
    populate_buf()
    return isValid
end

local function load_pinned_file(index)
    local fileToLoad = M.pinned_files[index]
    if fileToLoad == nil or fileToLoad == '' then
        print("No pinned file at -> " .. index)
        return
    end
    local isValid = valdidate_file(index)
    if isValid == false then
        print("No pinned file at -> " .. index)
        return
    end
    close_floating_window()
    local currentFile = vim.api.nvim_buf_get_name(0)
    if currentFile == fileToLoad then
        return
    end
    vim.cmd('edit ' .. vim.fn.fnameescape(fileToLoad))
end

local function delete_pinned_file()
    local lineNumber, _ = unpack(vim.api.nvim_win_get_cursor(0))
    if lineNumber < 1 or lineNumber > 5 then
        return
    end
    M.pinned_files[lineNumber] = ''
    populate_buf()
end

local function swap_pinned_files_positions(from, to)
    if from == to then return end
    if M.pinned_files[from] == '' and M.pinned_files[to] == '' then return end
    local original = M.pinned_files[to]
    M.pinned_files[to] = M.pinned_files[from]
    M.pinned_files[from] = original
end

local function set_buffer_keymaps()
    vim.keymap.set('n', '<esc>', close_floating_window, { buffer = M.buf, nowait = true })
    vim.keymap.set('n', 'q', close_floating_window, { buffer = M.buf, nowait = true })
    vim.keymap.set('n', '<M-e>', function()
        local lineNumber, _ = unpack(vim.api.nvim_win_get_cursor(0))
        load_pinned_file(lineNumber)
    end, { buffer = M.buf, nowait = true })
    vim.keymap.set('n', 'd', ':DeletePinnedFile<CR>', { desc = 'Delete pinned file', silent = true, buffer = M.buf })
    for i = 1, 5, 1 do
        vim.keymap.set('n', "<M-" .. i .. ">", function ()
            local lineNumber, _ = unpack(vim.api.nvim_win_get_cursor(0))
            swap_pinned_files_positions(lineNumber, i)
            populate_buf()
        end, { desc = 'Open tagged buf at ' .. i, silent = true, buffer = M.buf })
        vim.keymap.set('n', tostring(i), ':OpenPinnedFile' .. i .. '<CR>', { desc = 'Open tagged buf at ' .. i, silent = true, buffer = M.buf })
    end
end

local function toggle_window()
    if not vim.api.nvim_win_is_valid(M.win) then
        for index, filepath in ipairs(M.pinned_files) do
            if filepath ~= '' then
                valdidate_file(index)
            end
        end

        local longest_name = get_longest_name(M.pinned_files) + 15
        set_buffer_keymaps()
        populate_buf()
        M.win = create_floating_window {
            buf = M.buf,
            width = longest_name,
            height = 5,
            title = 'Pinned Files',
            style = ''
        }.win
    else
        vim.api.nvim_win_hide(M.win)
    end
end

local function pin_file(index)
    if index < 1 or index > 5 then return end
    local current = vim.api.nvim_get_current_buf()
    local bufName = vim.api.nvim_buf_get_name(current)
    if bufName == nil or bufName == '' then return end
    M.pinned_files[index] = bufName
end

local function save_pinned_files()
    for index, _ in ipairs(M.pinned_files) do
        valdidate_file(index)
    end
    save_load.save(data_file, M.pinned_files)
end

local function set_auto_commands()
    vim.api.nvim_create_autocmd('VimLeavePre', {
        callback = save_pinned_files,
    })
end

local function set_commands()
    vim.api.nvim_create_user_command('TogglePinnedFilesBrowser', toggle_window, {})
    vim.api.nvim_create_user_command('DeletePinnedFile', delete_pinned_file, {})
    vim.api.nvim_create_user_command('SetPinnedFile', function(opts)
        local buf_index = tonumber(opts.args)
        pin_file(buf_index)
    end, { nargs = 1 })
    vim.api.nvim_create_user_command('OpenPinnedFile', function(opts)
        local buf_index = tonumber(opts.args)
        load_pinned_file(buf_index)
    end, { nargs = 1 })
end

local function set_keymaps()
    vim.keymap.set('n', '<leader>b', ':TogglePinnedFilesBrowser<CR>',
        { desc = 'Toggle taged files browser', silent = true })
    for i = 1, 5, 1 do
        vim.keymap.set('n', '<leader>' .. i, ':OpenPinnedFile '.. i ..'<CR>', { desc = 'Open tagged buf at ' .. i, silent = true })
        vim.keymap.set('n', '<M-' .. i .. '>', ':SetPinnedFile' .. i .. '<CR>', { desc = 'Set tagged buf at '.. i, silent = true })
    end
end

M.setup = function()
    M.buf = vim.api.nvim_create_buf(false, true)
    local saved_pinned_files = save_load.load(data_file)
    if #saved_pinned_files > 0 then
        M.pinned_files = saved_pinned_files
    end
    populate_buf()
    set_auto_commands()
    set_commands()
    set_keymaps()
end

return M
