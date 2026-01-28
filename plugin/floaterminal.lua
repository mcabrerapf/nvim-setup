local create_floating_window = require 'utils.create-floating-window'
local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local toggle_terminal = function()
  if vim.api.nvim_buf_is_valid(state.floating.buf) then
    vim.api.nvim_buf_delete(state.floating.buf, { force = true })
  end
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window { buf = state.floating.buf }

    if vim.bo[state.floating.buf].buftype ~= 'terminal' then
      vim.cmd.terminal()
    end
    vim.keymap.set('n', '<esc>', function()
      vim.api.nvim_win_hide(state.floating.win)
    end, { buffer = state.floating.buf, nowait = true })
    vim.cmd 'startinsert'
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

vim.keymap.set('n', '<leader>tt', function()
  toggle_terminal()
end, {
  desc = 'Toggle floating terminal',
})
