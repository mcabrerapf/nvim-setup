local create_floating_window = require 'utils.create-floating-window'
local M = {
  floating = {
    buf = -1,
    win = -1,
  }
}

local function setup_buffer()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buflisted = false
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].swapfile = false
  M.floating.buf = buf
end

local toggle_terminal = function()
  if not vim.api.nvim_win_is_valid(M.floating.win) then
    setup_buffer()
    M.floating = create_floating_window { buf = M.floating.buf }

    vim.fn.jobstart(vim.o.shell, { term = true })
    vim.cmd 'startinsert'
    --
    vim.keymap.set('n', '<esc>', function()
      vim.api.nvim_win_hide(M.floating.win)
    end, { buffer = true, nowait = true })
    --
    vim.keymap.set('n', 'q', function()
      vim.api.nvim_win_hide(M.floating.win)
    end, { buffer = true, nowait = true })
  else
    vim.api.nvim_win_hide(M.floating.win)
    vim.api.nvim_buf_delete(M.floating.buf, {})
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
  set_commands()
  set_keymaps()
end

return M
