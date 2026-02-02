vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })
vim.keymap.set('n', '<M-j>', '<C-d>zz', { desc = 'Scroll half screen Down' })
vim.keymap.set('n', '<M-k>', '<C-u>zz', { desc = 'Scroll half screen Up' })
-- vim.keymap.set('n', '<C-M-j>', '<C-f>zz', { desc = 'Page Down' })
-- vim.keymap.set('n', '<C-M-k>', '<C-b>zz', { desc = 'Page Up' })
-- NOTE: Easy way to close terminal
vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>', { desc = 'Close terminal' })
vim.keymap.set('i', 'jkl', '<esc>', { desc = 'Quit insert mode' })
vim.keymap.set('n', '<S-l>', 'g_', { desc = 'Move to last character in line' })
vim.keymap.set('n', '<S-h>', '^', { desc = 'Move to first character in line' })
-- move around windows
vim.keymap.set('n', '<leader>j', '<C-w>j', { desc = 'move to bottom window' })
vim.keymap.set('n', '<leader>k', '<C-w>k', { desc = 'move to top window' })
-- NOTE: Diagnostic keymaps
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>tq', function()
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
end, { desc = 'Toggle [Q]uickfix list' })

vim.keymap.set('n', '<leader>b', function()
  vim.cmd 'bp'
end, { desc = 'previous buffer' })

vim.keymap.set('v', '<leader>w', function()
  vim.cmd('vimgrep /' .. vim.fn.expand '<cword>' .. '/ ./**')
  vim.cmd 'copen'
end, { desc = 'vim[g]rep highlighted word' })

vim.keymap.set({ 'n' }, '<leader><leader>s', function()
  vim.cmd 'w'
end, { desc = 'Save file' })

vim.keymap.set('n', '<leader><leader>q', function()
  vim.cmd 'bdelete'
end, { desc = 'Close buffer' })

vim.keymap.set('n', '<leader><leader>Q', function()
  vim.cmd 'qa'
end, { desc = 'QUIT NVIM' })

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
end, { desc = 'create session' })
