local M = {}

M.state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local function toggle_todo_note()
  local create_floating_window = require 'utils.create-floating-window'

  if not vim.api.nvim_win_is_valid(M.state.floating.win) then
    if vim.api.nvim_buf_is_valid(M.state.floating.buf) then
      M.state.floating.buf = M.state.floating.buf
    else
      M.state.floating.buf = vim.api.nvim_create_buf(false, false)
      local notes_dir = vim.env.NOTES_DIR_PATH
      local file_path = notes_dir .. '/' .. 'todo.md'
      if vim.fn.filereadable(file_path) == 0 then
        local file = io.open(file_path, 'w')
        if file then
          file:close()
        end
      end
      vim.api.nvim_buf_call(M.state.floating.buf, function()
        vim.cmd('read ' .. vim.fn.fnameescape(file_path))
        vim.cmd '1delete' -- remove the empty first line
      end)
      vim.api.nvim_buf_set_name(M.state.floating.buf, file_path)
      vim.api.nvim_buf_set_option(M.state.floating.buf, 'filetype', 'markdown')
    end
    M.state.floating = create_floating_window {
      buf = M.state.floating.buf,
      width = 30,
      height = 10,
      row = 0,
      col = vim.o.columns,
      title = 'TODO',
      -- border = '',
      fixed = true,
      should_enter = false,
    }
  else
    vim.api.nvim_win_hide(M.state.floating.win)
  end
end

local function create_note()
  local name = vim.fn.input 'New note name: '
  if name == '' then
    return
  end

  if not name:match '%.md$' then
    name = name .. '.md'
  end
  local notes_dir = vim.env.NOTES_DIR_PATH
  local file_path = notes_dir .. '/' .. name

  if vim.fn.filereadable(file_path) == 0 then
    local file = io.open(file_path, 'w')
    if file then
      file:close()
    end
  end
  vim.cmd('edit ' .. vim.fn.fnameescape(file_path))
  local readableName = name:gsub('%.[^%.]+$', ''):gsub('[-_]', ' '):gsub('^%l', string.upper)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, {
    '# ' .. readableName,
    '',
    '## Created: ' .. os.date '%Y-%m-%d %H:%M',
    '----------------------------',
    '',
  })
  vim.cmd 'normal G'
  vim.cmd 'startinsert'
end

local function browse_notes()
  local files = require 'mini.files'
  files.open(vim.env.NOTES_DIR_PATH, false)
end

local function set_commands()
  vim.api.nvim_create_user_command('NotesCreate', function()
    create_note()
  end, {})

  vim.api.nvim_create_user_command('NotesBrowse', function()
    browse_notes()
  end, {})

  vim.api.nvim_create_user_command('NotesTodoToggle', function()
    toggle_todo_note()
  end, {})
end

local function set_keymaps()
  vim.keymap.set('n', '<leader>nn', ':NotesCreate<CR>', { desc = 'Create & open new markdown note in nvim config', silent = true })
  --
  vim.keymap.set('n', '<leader>nf', ':NotesBrowse<CR>', { desc = 'browse notes', silent = true })
  --
  vim.keymap.set('n', '<leader>nd', ':NotesTodoToggle<CR>', { desc = 'toggle TODO notes', silent = true })
end

M.setup = function(opts)
  set_commands()
  set_keymaps()
end

return M
