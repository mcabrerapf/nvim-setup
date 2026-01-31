-- NOTE: [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })
-- NOTE: For faster navigation
vim.keymap.set('n', '<C-j>', '<C-d>zz', { desc = 'Page Down' })
vim.keymap.set('n', '<C-k>', '<C-u>zz', { desc = 'Page Up' })
-- NOTE: Easy way to close terminal
vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>')

-- NOTE: Diagnostic keymaps
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>q', function()
  local qf_open = false

  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      qf_open = true
      break
    end
  end

  if qf_open then
    vim.cmd 'cclose'
  else
    vim.cmd 'copen'
  end
end, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('v', '<leader>w', function()
  vim.cmd('vimgrep /' .. vim.fn.expand '<cword>' .. '/ ./**')
  vim.cmd 'copen'
end, { desc = 'vim[g]rep highlighted word' })

vim.keymap.set({ 'n', 'i' }, '<C-s>', function()
  vim.cmd 'w'
end, { desc = 'Save window' })
-- vim.keymap.set('n', '<C-c>', '<C-w>c', { desc = 'Close window' })

vim.keymap.set('n', '<leader>nn', function()
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
end, { desc = 'Create & open new markdown note in nvim config' })

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
  vim.cmd(':mksession ' .. file_path)
end, { desc = 'Save current session' })
