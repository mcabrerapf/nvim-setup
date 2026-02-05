local create_floating_window = require 'utils.create-floating-window'

local M = {
  state = {
    floating = {
      buf = -1,
      win = -1,
    },
  },
}
local notes_dir = vim.env.NOTES_DIR_PATH
local todo_note_filepath = notes_dir .. '/' .. 'todo.md'

local function setup_buffer()
  if vim.fn.filereadable(todo_note_filepath) == 0 then
    vim.fn.mkdir(vim.fn.fnamemodify(todo_note_filepath, ':h'), 'p')
    vim.fn.writefile({ '- [ ] First' }, todo_note_filepath)
  end
  M.state.floating.buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_option_value('modifiable', true, { buf = M.state.floating.buf })
  vim.bo[M.state.floating.buf].filetype = 'markdown'
  local lines = vim.fn.readfile(todo_note_filepath)
  vim.api.nvim_buf_set_lines(M.state.floating.buf, 0, -1, false, lines)
end

local function save_buffer_to_file()
  local buf = M.state.floating.buf
  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  vim.fn.writefile(lines, todo_note_filepath)
end

local function toggle_todo_task_check()
  local buf = vim.api.nvim_get_current_buf()
  if buf ~= M.state.floating.buf then
    return
  end

  local row = vim.api.nvim_win_get_cursor(0)[1] - 1
  local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1]
  if not line then
    return
  end
  if line:match '^%- %[% %]' then
    line = line:gsub('^%- %[% %]', '- [x]')
  elseif line:match '^%- %[x%]' then
    line = line:gsub('^%- %[x%]', '- [ ]')
  else
    return
  end
  vim.api.nvim_buf_set_lines(buf, row, row + 1, false, { line })
end

local function toggle_todo_note()
  if not vim.api.nvim_win_is_valid(M.state.floating.win) then
    local width = math.floor(vim.o.columns / 6)
    M.state.floating = create_floating_window {
      buf = M.state.floating.buf,
      width = width,
      height = 15,
      title = '- TODO -',
      should_enter = false,
      fixed = true,
      row = 0,
      col = vim.o.columns - (width + 2),
      border = { '.', '-', '.', '║', '.', '_', '.', '║' },
    }
  else
    vim.api.nvim_win_hide(M.state.floating.win)
  end
end

local function add_todo_task()
  local buf = M.state.floating.buf
  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  vim.ui.input({ prompt = 'New TODO task: ' }, function(input)
    if not input or input == '' then
      return
    end

    local line = '- [ ] ' .. input
    vim.api.nvim_buf_set_lines(buf, -1, -1, false, { line })
  end)
end

local function create_note()
  local name = vim.fn.input 'New note name: '
  if name == '' then
    return
  end

  if not name:match '%.md$' then
    name = name .. '.md'
  end
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

local function set_auto_commands()
  vim.api.nvim_create_autocmd('VimLeavePre', {
    callback = save_buffer_to_file,
  })
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

  vim.api.nvim_create_user_command('NotesTodoAdd', function()
    add_todo_task()
  end, {})
end

local function set_keymaps()
  vim.keymap.set('n', '<leader>nn', ':NotesCreate<CR>', { desc = 'Create & open new markdown note in nvim config', silent = true })

  vim.keymap.set('n', '<leader>nf', ':NotesBrowse<CR>', { desc = 'Browse notes', silent = true })

  vim.keymap.set('n', '<leader>nt', ':NotesTodoToggle<CR>', { desc = 'Toggle TODO notes', silent = true })

  vim.keymap.set('n', '<leader>na', ':NotesTodoAdd<CR>', { desc = 'Add task to TODO', silent = true })

  vim.keymap.set('n', '<M-n>', toggle_todo_task_check, { desc = 'Mark TODO as done', silent = true, buffer = M.state.floating.buf })
end

M.setup = function(opts)
  setup_buffer()
  set_auto_commands()
  set_commands()
  set_keymaps()
end

return M
