local M = {}

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
end

local function set_keymaps()
  vim.keymap.set('n', '<leader>nn', ':NotesCreate<CR>', { desc = 'Create & open new markdown note in nvim config', silent = true })
  --
  vim.keymap.set('n', '<leader>nf', ':NotesBrowse<CR>', { desc = 'browse notes', silent = true })
end

M.setup = function(opts)
  set_commands()
  set_keymaps()
end

return M
