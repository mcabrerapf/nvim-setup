-- NOTE: [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })
vim.keymap.set('n', '<C-j>', '<C-d>zz', { desc = 'Page Down' })
vim.keymap.set('n', '<C-k>', '<C-u>zz', { desc = 'Page Up' })
-- NOTE: Easy way to close terminal
vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>')

-- NOTE: Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- NOTE: File explorers shorcuts

-- vim.keymap.set('n', '<leader>cd', function()
--   vim.cmd 'Ex'
-- end, { desc = 'Open file Explorer' })
--
-- vim.keymap.set('n', '<leader>cl', function()
--   vim.cmd 'Lex'
--   vim.cmd 'vertical resize 35'
-- end, {
--   desc = 'Open file explorer LEX',
-- })

-- Godot keybinds
-- Shortcut to Godot Projects
-- vim.keymap.set('n', '<leader>gp', function()
--   vim.cmd 'Lex F:/godot games'
--   vim.cmd 'vertical resize 35'
-- end, {
--   desc = 'Go to Godot Projects',
-- })

vim.keymap.set('n', '<leader>gc', function()
  local target = '127.0.0.1:6004'
  local servers = vim.fn.serverlist()
  -- NOTE:
  -- In Godot add this to the Editor Settings > External > Exec flags > --server 127.0.0.1:6004 --remote-send "<C-\><C-N>:wincmd l | edit {file}<CR>{line}G{col}"
  if not vim.tbl_contains(servers, target) then
    vim.fn.serverstart(target)
    print('Started Vim/Godot server at ' .. target)
  else
    print('Vim/Godot server already running at ' .. target)
  end
end, {
  desc = 'Start Vim/Godot server',
  noremap = true,
})

-- NOTE: Godot snippets
vim.keymap.set('n', '<leader>gsf', function()
  local buf = vim.api.nvim_get_current_buf()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local indent = vim.fn.indent(row)
  local prefix = string.rep(' ', indent)

  vim.api.nvim_buf_set_lines(buf, row, row, false, {
    prefix .. 'func _() -> void:',
    prefix .. '\treturn',
  })

  local col = prefix:len() + #'func _'
  vim.api.nvim_win_set_cursor(0, { row + 1, col })
  vim.cmd 'startinsert'
end, { desc = 'Godot function snippet' })
