-- WARN: Make sure both godot.exe AND the projects folder are in the same drive
local create_floating_window = require 'utils.create-floating-window'
local get_directories = require 'utils.get-directories'
local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local function get_longest_dir_name(dirs)
  local max_len = 0
  for _, name in ipairs(dirs) do
    local len = #name -- get the length of the string
    if len > max_len then
      max_len = len
    end
  end
  return max_len
end

local function start_godot_server()
  local target = vim.env.GODOT_SERVER_PORT
  local servers = vim.fn.serverlist()
  -- NOTE: In Godot add this to in
  -- Editor Settings > External > Exec flags > --server {godo_port} --remote-send "<C-\><C-N>:wincmd l | edit {file}<CR>{line}G{col}"
  if not vim.tbl_contains(servers, target) then
    vim.fn.serverstart(target)
  end
end

local function open_godot(project_path)
  vim.fn.jobstart({
    'cmd.exe',
    '/c',
    vim.env.GODOT_EXE_PATH,
    '--editor',
    '--path',
    project_path,
  }, { detach = true })
end

local function populate_buffer(buf, dirs)
  vim.api.nvim_buf_set_option(buf, 'modifiable', true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, dirs)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)

  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].bufhidden = 'hide'
  vim.bo[buf].filetype = 'project_picker'
end

local function get_selected_project_path()
  local line = vim.api.nvim_get_current_line()
  if line == '' then
    return ''
  end
  return vim.env.GODOT_PROJECTS_PATH .. '/' .. line
end

local function open_project(project_path)
  if vim.api.nvim_win_is_valid(state.floating.win) then
    vim.api.nvim_win_close(state.floating.win, true)
  end
  if project_path == '' then
    return
  end
  vim.cmd 'tabnew'
  vim.cmd('tcd ' .. project_path)
  require('mini.files').open(vim.uv.cwd(), true)
end

local toggle_project_picker = function()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    local dirs = get_directories(vim.env.GODOT_PROJECTS_PATH)
    local longest_dir_name = get_longest_dir_name(dirs)
    state.floating = create_floating_window { buf = state.floating.buf, width = longest_dir_name, height = 10 }
    populate_buffer(state.floating.buf, dirs)

    vim.keymap.set('n', 'q', function()
      vim.api.nvim_win_hide(state.floating.win)
    end, { buffer = state.floating.buf, nowait = true })
    --
    vim.keymap.set('n', 'L', function()
      local project_path = get_selected_project_path()
      open_project(project_path)
      open_godot(project_path)
      start_godot_server()
    end, { buffer = state.floating.buf, nowait = true })
    --
    vim.keymap.set('n', 'l', function()
      local project_path = get_selected_project_path()
      open_project(project_path)
      start_godot_server()
    end, { buffer = state.floating.buf, nowait = true })
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

vim.keymap.set('n', '<leader>fg', function()
  toggle_project_picker()
end, {
  desc = '[g]odot',
})
