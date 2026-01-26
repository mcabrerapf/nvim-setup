local PROJECTS_ROOT = 'F:/Godot Games/'
local create_floating_window = require 'utils.create-floating-window'
local get_directories = require 'utils.get-directories'
local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local function populate_buffer(buf, root)
  local dirs = get_directories(root)

  vim.api.nvim_buf_set_option(buf, 'modifiable', true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, dirs)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)

  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].bufhidden = 'hide'
  vim.bo[buf].filetype = 'project_picker'
end

local function open_project(root)
  local line = vim.api.nvim_get_current_line()
  if line == '' then
    return
  end

  local path = root .. '/' .. line

  -- Close floating window
  if vim.api.nvim_win_is_valid(state.floating.win) then
    vim.api.nvim_win_close(state.floating.win, true)
  end
  -- vim.g.netrw_liststyle = 3
  -- Open Lexplore in a new tab
  vim.cmd 'tabnew'
  vim.cmd('NvimTreeOpen ' .. vim.fn.fnameescape(path))
  -- vim.cmd 'vertical resize 35'
  -- vim.cmd ':normal iii'
  -- vim.cmd ':normal cd'
  local target = '127.0.0.1:6004'
  local servers = vim.fn.serverlist()
  -- In Godot add this to the Editor Settings > External > Exec flags > --server 127.0.0.1:6004 --remote-send "<C-\><C-N>:wincmd l | edit {file}<CR>{line}G{col}"
  if not vim.tbl_contains(servers, target) then
    vim.fn.serverstart(target)
    print('Started Vim/Godot server at ' .. target)
  else
    print('Vim/Godot server already running at ' .. target)
  end
end

local toggle_project_picker = function()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window { buf = state.floating.buf }

    populate_buffer(state.floating.buf, PROJECTS_ROOT)

    -- Buffer-local mappings
    vim.keymap.set('n', '<esc>', function()
      vim.api.nvim_win_hide(state.floating.win)
    end, { buffer = state.floating.buf, nowait = true })
    vim.keymap.set('n', '<CR>', function()
      open_project(PROJECTS_ROOT)
    end, { buffer = state.floating.buf, nowait = true })
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

-- Example usage:
-- Create a floating window with default dimensions
-- vim.api.nvim_create_user_command('GodotProjectsWindow', get_directories, {})
vim.keymap.set('n', '<leader>gl', function()
  -- vim.cmd 'GodotProjectsWindow'
  toggle_project_picker()
end, {
  desc = 'Open godot projects picker',
})
