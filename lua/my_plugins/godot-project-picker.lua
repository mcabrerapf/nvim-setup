local create_floating_window = require 'utils.create-floating-window'
local get_directories = require 'utils.get-directories'
local get_longest_name = require 'utils.get-longest-string'
local populate_buffer = require 'utils.populate-buffer'

local M = {
  state = {
    floating = {
      buf = -1,
      win = -1,
    },
    current_session = ''
  }
}

local function updated_godot_session()
  if not M.current_session or M.current_session == '' then
    return
  end
  vim.cmd('mksession! ' .. M.current_session)
end

local function load_godot_session(project_path)
  M.current_session = project_path .. '/session.vim'
  if vim.fn.filereadable(M.current_session) == 1 then
    vim.cmd('source ' .. M.current_session)
  else
    vim.cmd('mksession ' .. M.current_session)
  end
end

local function start_godot_server()
  local target = vim.env.GODOT_SERVER_PORT
  local servers = vim.fn.serverlist()
  -- NOTE: In Godot add this in Editor Settings > External > Exec flags > --server {godo_port} --remote-send "<C-\><C-N>:wincmd l | edit {file}<CR>{line}G{col}"
  if vim.tbl_contains(servers, target) then
    vim.fn.serverstop(target)
  end
  vim.fn.serverstart(target)
end

local function open_godot(project_path)
  if vim.fn.filereadable(vim.env.GODOT_EXE_PATH) == 1 then
    vim.system({
      "cmd.exe",
      "/c",
      "start",
      "",
      vim.env.GODOT_EXE_PATH,
      "--editor",
      "--path",
      project_path,
    })
    -- vim.system({
    --   vim.env.GODOT_EXE_PATH,
    --   "--editor",
    --   "--path",
    --   project_path,
    -- }, {
    --   stdout = false,
    --   stderr = false,
    --   text = false,
    --   detach = true,
    -- })
  end
end

local function get_selected_project_path()
  local line = vim.api.nvim_get_current_line()
  if line == '' then
    return ''
  end
  return vim.env.GODOT_PROJECTS_PATH .. '/' .. line
end

local function open_project(project_path)
  if vim.api.nvim_win_is_valid(M.state.floating.win) then
    vim.api.nvim_win_close(M.state.floating.win, true)
  end
  if project_path == '' then
    return
  end
  vim.cmd('tcd ' .. project_path)
end

local toggle_project_picker = function()
  if not vim.api.nvim_win_is_valid(M.state.floating.win) then
    local dirs = get_directories(vim.env.GODOT_PROJECTS_PATH)
    local longest_dir_name = get_longest_name(dirs)
    if longest_dir_name < 25 then
      longest_dir_name = 25
    end
    M.state.floating = create_floating_window { buf = M.state.floating.buf, width = longest_dir_name, height = 10, title = 'Godot Projects' }
    populate_buffer(M.state.floating.buf, dirs, { filetype = 'godot_project_picker' })
    --
    vim.keymap.set('n', '<esc>', function()
      vim.api.nvim_win_hide(M.state.floating.win)
    end, { buffer = M.state.floating.buf, nowait = true })
    --
    vim.keymap.set('n', 'q', function()
      vim.api.nvim_win_hide(M.state.floating.win)
    end, { buffer = M.state.floating.buf, nowait = true })
    --
    vim.keymap.set('n', '<M-e>', function()
      local project_path = get_selected_project_path()
      open_godot(project_path)
      -- start_godot_server()
      -- open_project(project_path)
      -- load_godot_session(project_path)
    end, { buffer = M.state.floating.buf, nowait = true })
    --
    vim.keymap.set('n', 'l', function()
      local project_path = get_selected_project_path()
      start_godot_server()
      open_project(project_path)
      load_godot_session(project_path)
    end, { buffer = M.state.floating.buf, nowait = true })
  else
    vim.api.nvim_win_hide(M.state.floating.win)
  end
end

local function godot_script_search()
  local filename_first = require 'utils.filename-first'
  local pick = require 'mini.pick'
  local items = vim.fn.glob('**/*.gd', false, true)
  pick.start({ source = { items = items, show = filename_first, name = "Godot script search" } })
end

local function set_auto_commands()
  vim.api.nvim_create_autocmd('VimLeavePre', {
    callback = updated_godot_session,
  })
end

local function set_commands()
  vim.api.nvim_create_user_command('GodotPickerCurrent', function()
    print('Current Godot session -> ' .. M.current_session)
  end, {})
  --
  vim.api.nvim_create_user_command('GodotPickerToggle', toggle_project_picker, {})
  vim.api.nvim_create_user_command('GodotScriptSearch', godot_script_search, {})
  vim.api.nvim_create_user_command('GodotStartServer', start_godot_server, {})
  vim.api.nvim_create_user_command('GodotRestartLsp', function()
    local clients = vim.lsp.get_clients(vim.lsp.get_clients({ name = 'gdscript' }))
    for index, client in ipairs(clients) do
      vim.lsp.stop_client(client.id)
    end
    vim.cmd('LspStart gdscript')
    vim.defer_fn(function()
      vim.cmd('e')
    end, 500)
    start_godot_server()
  end, {})
end

local function set_keymaps()
  vim.keymap.set('n', '<leader>fg', ':GodotPickerToggle<CR>', {
    desc = '[g]odot projects',
    silent = true,
  })
  vim.keymap.set('n', '<leader>sg', ':GodotScriptSearch<CR>', { desc = '[s]earch [g]odot scripts', silent = true })
end

M.setup = function(opts)
  -- WARN: Make sure both godot.exe AND the projects folder are in the same drive
  if not vim.env.GODOT_SERVER_PORT or not vim.env.GODOT_PROJECTS_PATH or not vim.env.GODOT_EXE_PATH then
    return
  else
    M.state.floating.buf = vim.api.nvim_create_buf(false, true)
    set_auto_commands()
    set_commands()
    set_keymaps()
  end
end

return M
