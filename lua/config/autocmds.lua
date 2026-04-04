-- Add highlight to todo, note and bug
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*",
  desc = 'todo comment highlights',
  callback = function()
    vim.fn.matchadd('TodoComment', 'TODO:')
    vim.fn.matchadd('NoteComment', 'NOTE:')
    vim.fn.matchadd('BugComment', 'BUG:')
  end
})
-- highlight text on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', { clear = true }),
  pattern = '*',
  desc = 'highlight selection on yank',
  callback = function()
    vim.highlight.on_yank { timeout = 200, visual = true }
  end,
})
-- restore cursor to file position in previous editing session
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.api.nvim_win_set_cursor(0, mark)
      -- defer centering slightly so it's applied after render
      vim.schedule(function()
        vim.cmd 'normal! zz'
      end)
    end
  end,
})
-- open help in vertical split
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'help', 'h' },
  command = 'wincmd L',
})
-- show cursorline only in active window enable
vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
  group = vim.api.nvim_create_augroup('active_cursorline', { clear = true }),
  callback = function()
    vim.opt_local.cursorline = true
  end,
})

vim.api.nvim_create_autocmd({ 'WinLeave', 'BufLeave' }, {
  group = 'active_cursorline',
  callback = function()
    vim.opt_local.cursorline = false
  end,
})
