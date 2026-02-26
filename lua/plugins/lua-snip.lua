return {
  'L3MON4D3/LuaSnip',
  version = '2.*',
  build = (function()
    -- Build Step is needed for regex support in snippets.
    -- This step is not supported in many windows environments.
    -- Remove the below condition to re-enable on windows.
    if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
      return
    end
    return 'make install_jsregexp'
  end)(),
  config = function()
    local ls = require 'luasnip'
    ls.setup {
      enable_autosnippets = true,
      update_events = 'TextChanged,TextChangedI',
      snip_env = {
        s = function(...)
          local snip = ls.s(...)
          table.insert(getfenv(2).ls_file_snippets, snip)
        end,
        parse = function(...)
          local snip = ls.parser.parse_snippet(...)
          table.insert(getfenv(2).ls_file_snippets, snip)
        end,
      },
      -- cut_selection_keys = '',
    }
    vim.keymap.set('i', '<esc>', function()
      if ls.get_active_snip() then
        ls.unlink_current()
      else
        vim.cmd('stopinsert')
      end
    end, { silent = true })

    require('luasnip.loaders.from_lua').load {
      paths = vim.fn.stdpath 'config' .. '/lua/snippets',
    }
  end,
}
