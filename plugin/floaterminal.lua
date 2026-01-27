local create_floating_window = require 'utils.create-floating-window'
local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local toggle_terminal = function()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window { buf = state.floating.buf }
    if vim.bo[state.floating.buf].buftype ~= 'terminal' then
      vim.cmd.terminal()
      vim.cmd 'startinsert'
    end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end
--
-- -- Example usage:
-- -- Create a floating window with default dimensions
vim.api.nvim_create_user_command('Floaterminal', toggle_terminal, {})
vim.keymap.set('n', '<leader>tt', function()
  vim.cmd 'Floaterminal'
end, {
  desc = 'Toggle floating terminal',
})
