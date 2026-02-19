local create_floating_window = require 'utils.create-floating-window'
local M = {
  state = {
    floating = {
      buf = -1,
      win = -1,
    }
  }
}

local function setup_buffer()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buflisted = false
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].swapfile = false
  M.state.floating.buf = buf
end

local toggle_terminal = function()
  if not vim.api.nvim_win_is_valid(M.state.floating.win) then
    setup_buffer()
    M.state.floating = create_floating_window { buf = M.state.floating.buf }

    vim.fn.jobstart(vim.o.shell, { term = true })
    vim.cmd 'startinsert'
    --
    vim.keymap.set('n', '<esc>', function()
      vim.api.nvim_win_hide(M.state.floating.win)
    end, { buffer = M.state.floating.buf, nowait = true })
    --
    vim.keymap.set('n', 'q', function()
      vim.api.nvim_win_hide(M.state.floating.win)
    end, { buffer = M.state.floating.buf, nowait = true })
  else
    vim.api.nvim_win_hide(M.state.floating.win)
    vim.api.nvim_buf_delete(M.state.floating.buf, {})
  end
end

local function set_commands()
  vim.api.nvim_create_user_command('FloTermToggle', function()
    toggle_terminal()
  end, {})
end

local function set_keymaps()
  vim.keymap.set('n', '<leader>tt', ':FloTermToggle<CR>', {
    desc = 'Toggle floating terminal',
    silent = true,
  })
end

M.setup = function(opts)
  -- TODO: FIX THIS
  -- setup_buffer()
  set_commands()
  set_keymaps()
end

return M
