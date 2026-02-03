local M = {}

M.state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local toggle_terminal = function()
  if vim.api.nvim_buf_is_valid(M.state.floating.buf) then
    vim.api.nvim_buf_delete(M.state.floating.buf, { force = true })
  end
  if not vim.api.nvim_win_is_valid(M.state.floating.win) then
    local create_floating_window = require 'utils.create-floating-window'
    M.state.floating = create_floating_window { buf = M.state.floating.buf }

    if vim.bo[M.state.floating.buf].buftype ~= 'terminal' then
      vim.cmd.terminal()
    end
    vim.keymap.set('n', '<esc>', function()
      vim.api.nvim_win_hide(M.state.floating.win)
    end, { buffer = M.state.floating.buf, nowait = true })
    vim.keymap.set('n', 'q', function()
      vim.api.nvim_win_hide(M.state.floating.win)
    end, { buffer = M.state.floating.buf, nowait = true })
    vim.cmd 'startinsert'
  else
    vim.api.nvim_win_hide(M.state.floating.win)
  end
end

local function set_commands()
  vim.api.nvim_create_user_command('FloTermToggle', function()
    toggle_terminal()
  end, {})
end

local function set_keymaps()
  vim.keymap.set('n', '<leader>tt', function()
    toggle_terminal()
  end, {
    desc = 'Toggle floating terminal',
  })
end

M.setup = function(opts)
  set_commands()
  set_keymaps()
end

return M
