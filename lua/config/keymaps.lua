vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })
vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>', { desc = 'Close terminal' })
vim.keymap.set('i', 'lkj', '<esc>', { desc = 'Quit insert mode' })
-- vim.keymap.set('n', '<C-M-j>', '<C-f>', { desc = 'Page Down' })
-- vim.keymap.set('n', '<C-M-k>', '<C-b>', { desc = 'Page Up' })
-- NOTE: Easy way to close terminal
vim.keymap.set('n', '<M-j>', '<C-d>', { desc = 'Scroll half screen Down' })
vim.keymap.set('n', '<M-k>', '<C-u>', { desc = 'Scroll half screen Up' })
vim.keymap.set('n', '<M-l>', 'g_', { desc = 'Move to last character in line' })
vim.keymap.set('n', '<M-h>', '^', { desc = 'Move to first character in line' })
-- move around windows
vim.keymap.set('n', '<Down>', '<C-w>j', { desc = 'move to bottom window' })
vim.keymap.set('n', '<Up>', '<C-w>k', { desc = 'move to top window' })
vim.keymap.set('n', '<Left>', '<C-w>h', { desc = 'move to left window' })
vim.keymap.set('n', '<Right>', '<C-w>l', { desc = 'move to right window' })
-- NOTE: Diagnostic keymaps
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>tl', function()
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

vim.keymap.set('n', '<leader>qk', function()
  vim.cmd 'cp'
end, { desc = 'Go to prev quickfix item' })

vim.keymap.set('n', '<leader>qj', function()
  vim.cmd 'cn'
end, { desc = 'Go to next quickfix item' })

vim.keymap.set('n', '<leader>b', '<C-^>', { desc = 'Switch to last buffer' })

vim.keymap.set('v', '<leader>w', function()
  vim.cmd('vimgrep /' .. vim.fn.expand '<cword>' .. '/ ./**')
  vim.cmd 'copen'
end, { desc = 'vim[g]rep highlighted word' })

vim.keymap.set('n', '<leader><leader>s', function()
  local buf_name = vim.api.nvim_buf_get_name(0)
  if buf_name == '' then
    return
  end
  local currentBufId = vim.api.nvim_get_current_buf()
  if vim.api.nvim_buf_is_valid(currentBufId)
      and vim.bo[currentBufId].buflisted
      and vim.bo[currentBufId].modifiable
      and vim.bo[currentBufId].modified
  then
    vim.cmd('w')
  end
end, { desc = 'Save file' })

vim.keymap.set('n', '<leader><leader>S', function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf)
        and vim.api.nvim_buf_get_name(buf) ~= ''
        and vim.bo[buf].buflisted
        and vim.bo[buf].modifiable
        and vim.bo[buf].modified
    then
      vim.api.nvim_buf_call(buf, function()
        vim.cmd('w')
      end)
    end
  end
end, { desc = 'Save all files' })

vim.keymap.set('n', '<leader><leader><M-q>', function()
  vim.cmd 'qa'
end, { desc = 'QUIT NVIM' })
