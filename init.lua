require 'utils.load-env' ()

if vim.fn.isdirectory(vim.env.NOTES_DIR_PATH) == 0 then
    vim.fn.mkdir(vim.env.NOTES_DIR_PATH, 'p')
end
if vim.fn.isdirectory(vim.env.SESSIONS_DIR_PATH) == 0 then
    vim.fn.mkdir(vim.env.SESSIONS_DIR_PATH, 'p')
end
-- vim.cmd('packadd nohlsearch')
vim.cmd('packadd nvim.undotree')
require 'config.options'
require 'config.keymaps'
require 'config.autocmds'
require 'my_plugins'

-- Experimental UI2: floating cmdline and messages
require('vim._core.ui2').enable({
  enable = true,
  msg = {
    targets = {
      [''] = 'msg',
      empty = 'cmd',
      bufwrite = 'msg',
      confirm = 'cmd',
      emsg = 'pager',
      echo = 'msg',
      echomsg = 'msg',
      echoerr = 'pager',
      completion = 'cmd',
      list_cmd = 'pager',
      lua_error = 'pager',
      lua_print = 'msg',
      progress = 'pager',
      rpc_error = 'pager',
      quickfix = 'msg',
      search_cmd = 'cmd',
      search_count = 'cmd',
      shell_cmd = 'pager',
      shell_err = 'pager',
      shell_out = 'pager',
      shell_ret = 'msg',
      undo = 'msg',
      verbose = 'pager',
      wildlist = 'cmd',
      wmsg = 'msg',
      typed_cmd = 'cmd',
    },
    cmd = {
      height = 0.5,
    },
    dialog = {
      height = 0.5,
    },
    msg = {
      height = 0.3,
      timeout = 3000,
    },
    pager = {
      height = 0.5,
    },
  },
})
