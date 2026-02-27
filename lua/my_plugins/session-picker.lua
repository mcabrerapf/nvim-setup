local M = {
  floating = {
    buf = -1,
    win = -1,
  },
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
  local create_floating_window = require 'utils.create-floating-window'
  local get_longest_filename = require 'utils.get-longest-string'
  local populate_buffer = require 'utils.populate-buffer'

  if not vim.api.nvim_win_is_valid(M.floating.win) then
    local sessions = get_sessions(vim.env.SESSIONS_DIR_PATH)
    local longest_session_name = get_longest_filename(sessions)
    if longest_session_name < 25 then
      longest_session_name = 25
    end
    M.floating = create_floating_window { buf = M.floating.buf, width = longest_session_name, height = 10, title = 'Sessions' }
    populate_buffer(M.floating.buf, sessions, { filetype = 'session_picker' })
    --
    vim.keymap.set('n', 'q', function()
      vim.api.nvim_win_hide(M.floating.win)
    end, { buffer = M.floating.buf, nowait = true })
    vim.keymap.set('n', '<esc>', function()
      vim.api.nvim_win_hide(M.floating.win)
    end, { buffer = M.floating.buf, nowait = true })
    --
    vim.keymap.set('n', 'q', function()
      vim.api.nvim_win_hide(M.floating.win)
    end, { buffer = M.floating.buf, nowait = true })
    --
    vim.keymap.set('n', 'l', function()
      M.current_session = get_selected_session_path()
      vim.api.nvim_win_hide(M.floating.win)
      vim.cmd '%bd'
      vim.cmd('source ' .. M.current_session)
    end, { buffer = M.floating.buf, nowait = true })
    --
  else
    vim.api.nvim_win_hide(M.floating.win)
  end
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

M.setup = function(opts)
  M.floating.buf = vim.api.nvim_create_buf(false, true)
  set_commands()
  set_keymaps()
end

return M
