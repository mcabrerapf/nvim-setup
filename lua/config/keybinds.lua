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
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('v', '<leader>w', function()
  vim.cmd('vimgrep /' .. vim.fn.expand '<cword>' .. '/ ./**')
  vim.cmd 'copen'
end, { desc = 'vim[g]rep highlighted word' })
