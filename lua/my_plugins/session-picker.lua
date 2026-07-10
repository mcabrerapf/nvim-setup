local create_floating_window = require 'utils.create-floating-window'
local get_longest_filename = require 'utils.get-longest-string'

local M = {
    current_session = ''
}

local function get_sessions(root)
    local files = {}
    for _, name in ipairs(vim.fn.readdir(root)) do
        local full = root .. '/' .. name
        if vim.fn.isdirectory(full) == 0 and name:match '%.vim$' then
            table.insert(files, name)
        end
    end
    return files
end

local function get_selected_session_path()
    local line = vim.api.nvim_get_current_line()
    if line == '' then
        return ''
    end
    return vim.env.SESSIONS_DIR_PATH .. '/' .. line
end

local toggle_session_picker = function()
    local buf = vim.api.nvim_create_buf(false, true)
    local sessions = get_sessions(vim.env.SESSIONS_DIR_PATH)
    if #sessions < 1 then
        vim.notify("No saved sessions", vim.log.levels.WARN)
        return
    end
    local longest_session_name = get_longest_filename(sessions)
    if longest_session_name < 25 then
        longest_session_name = 25
    end
    local win = create_floating_window { buf = buf, width = longest_session_name, height = 10, title = 'Sessions' }
    vim.keymap.set('n', 'q', function()
        vim.api.nvim_win_close(win, true)
    end, { buffer = buf })
    vim.keymap.set('n', '<esc>', function()
        vim.api.nvim_win_close(win, true)
    end, { buffer = buf })
    vim.keymap.set('n', 'l', function()
        M.current_session = get_selected_session_path()
        vim.api.nvim_win_close(win, true)
        vim.cmd '%bd'
        vim.cmd('source ' .. M.current_session)
    end, { buffer = buf })
end

local function create_session()
    local name = vim.fn.input 'Session name: '
    if name == '' then
        return
    end
    if not name:match '%.vim$' then
        name = name .. '.vim'
    end
    local file_path = vim.env.SESSIONS_DIR_PATH .. '/' .. name
    vim.cmd(':mksession ' .. file_path)
    M.current_session = file_path
end

local function create_session_in_current_pwd()
    local file_path = vim.fn.getcwd() .. '/' .. 'session.vim'
    vim.cmd(':mksession ' .. file_path)
    M.current_session = file_path
end

local function update_current_session()
    if not M.current_session or M.current_session == '' then
        return
    end
    vim.cmd(':mksession! ' .. M.current_session)
end

local function set_commands()
    vim.api.nvim_create_user_command('SeshPickCurrent', function()
        print(M.current_session)
    end, {})
    --
    vim.api.nvim_create_user_command('SeshPickToggle', function()
        toggle_session_picker()
    end, {})
    --
    vim.api.nvim_create_user_command('SeshPickCreate', function()
        create_session()
    end, {})
    --
    vim.api.nvim_create_user_command('SeshPickCreatePwd', function()
        create_session_in_current_pwd()
    end, {})
    --
    vim.api.nvim_create_user_command('SeshPickUpdate', function()
        update_current_session()
    end, {})
end

local function set_keymaps()
    vim.keymap.set('n', '<leader>en', ':SeshPickCreate<CR>', { desc = 'Create session', silent = true })
    --
    vim.keymap.set('n', '<leader>eN', ':SeshPickCreatePwd<CR>', { desc = 'Create session in current pwd', silent = true })
    --
    vim.keymap.set('n', '<leader>ef', ':SeshPickToggle<CR>', { desc = 'Browse sessions', silent = true })
    --
    vim.keymap.set('n', '<leader>es', ':SeshPickUpdate<CR>', { desc = 'Save current session', silent = true })
end

M.setup = function()
    set_commands()
    set_keymaps()
end

return M
