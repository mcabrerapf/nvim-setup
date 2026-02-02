local create_floating_window = require 'utils.create-floating-window'

local current_sesion = ''
local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local get_sessions = function(root)
  local files = {}
  for _, name in ipairs(vim.fn.readdir(root)) do
    local full = root .. '/' .. name
    if vim.fn.isdirectory(full) == 0 and name:match '%.vim$' then
      table.insert(files, name)
    end
  end
  return files
end

local function get_longest_session_name(sessions)
  local max_len = 10
  for _, name in ipairs(sessions) do
    local len = #name
    if len > max_len then
      max_len = len
    end
  end
  return max_len
end

local function populate_buffer(buf, sessions)
  vim.api.nvim_buf_set_option(buf, 'modifiable', true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, sessions)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)

  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].bufhidden = 'hide'
  vim.bo[buf].filetype = 'session_picker'
end

local function get_selected_session_path()
  local line = vim.api.nvim_get_current_line()
  if line == '' then
    return ''
  end
  return vim.env.SESSIONS_DIR_PATH .. '/' .. line
end

local toggle_session_picker = function()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    local sessions = get_sessions(vim.env.SESSIONS_DIR_PATH)
    local longest_session_name = get_longest_session_name(sessions)
    state.floating = create_floating_window { buf = state.floating.buf, width = longest_session_name, height = 10, title = 'Sessions' }
    populate_buffer(state.floating.buf, sessions)

    vim.keymap.set('n', 'q', function()
      vim.api.nvim_win_hide(state.floating.win)
    end, { buffer = state.floating.buf, nowait = true })
    --
    vim.keymap.set('n', 'l', function()
      current_sesion = get_selected_session_path()
      vim.api.nvim_win_hide(state.floating.win)
      vim.cmd '%bd'
      vim.cmd('source ' .. current_sesion)
    end, { buffer = state.floating.buf, nowait = true })
    --
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

vim.keymap.set('n', '<leader>en', function()
  local name = vim.fn.input 'Session name: '
  if name == '' then
    return
  end
  if not name:match '%.vim$' then
    name = name .. '.vim'
  end
  local sessions_dir = vim.env.SESSIONS_DIR_PATH
  local file_path = sessions_dir .. '/' .. name
  vim.cmd('mksession ' .. file_path)
  current_sesion = file_path
end, { desc = 'create session' })
--
vim.keymap.set('n', '<leader>eN', function()
  local sessions_dir = vim.env.SESSIONS_DIR_PATH
  local file_path = vim.fn.getcwd() .. '/' .. 'session.vim'
  vim.cmd('mksession ' .. file_path)
  current_sesion = file_path
end, { desc = 'create session in current pwd' })
--
vim.keymap.set('n', '<leader>ef', function()
  toggle_session_picker()
end, { desc = 'browser sessions' })
--
vim.keymap.set('n', '<leader>es', function()
  if not current_sesion or current_sesion == '' then
    return
  end
  vim.cmd('mksession! ' .. current_sesion)
end, { desc = 'update current session' })
