vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })
vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>', { desc = 'Close terminal' }) -- NOTE: Easy way to close terminal

vim.keymap.set('n', '<M-j>', '<C-d>', { desc = 'Scroll half screen Down' })
vim.keymap.set('n', '<M-k>', '<C-u>', { desc = 'Scroll half screen Up' })
vim.keymap.set('n', '<M-l>', 'g_', { desc = 'Move to last character in line' })
vim.keymap.set('n', '<M-h>', '^', { desc = 'Move to first character in line' })
-- move around windows
vim.keymap.set('n', '<Down>', '<C-w>j', { desc = 'move to bottom window' })
vim.keymap.set('n', '<Up>', '<C-w>k', { desc = 'move to top window' })
vim.keymap.set('n', '<Left>', '<C-w>h', { desc = 'move to left window' })
vim.keymap.set('n', '<Right>', '<C-w>l', { desc = 'move to right window' })
--
vim.keymap.set('n', '<leader>.', '<C-^>', { desc = 'Switch to last buffer' })
vim.keymap.set('n', '<leader><M-g>', function()
  vim.cmd('!git-bash')
end, { desc = 'Open [g]it bash', silent = true })
