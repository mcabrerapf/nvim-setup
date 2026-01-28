return {
  'L3MON4D3/LuaSnip',
  version = '2.*',
  build = (function()
    -- Build Step is needed for regex support in snippets.
    -- This step is not supported in many windows environments.
    -- Remove the below condition to re-enable on windows.
    -- if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
    --   return
    return 'make install_jsregexp'
  end)(),
  dependencies = {
    -- `friendly-snippets` contains a variety of premade snippets.
    --    See the README about individual language/framework/plugin snippets:
    --    https://github.com/rafamadriz/friendly-snippets
    -- {
    --   'rafamadriz/friendly-snippets',
    --   config = function()
    --     require('luasnip.loaders.from_vscode').lazy_load()
    --   end,
    -- },
  },
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

    -- NOTE: KEYMAPS
    vim.keymap.set({ 'i', 's' }, '<C-A>', function()
      print(ls.expand_or_jumpable)
      if ls.expand_or_jumpable then
        ls.expand_or_jump()
      end
    end, { silent = true })
    vim.keymap.set({ 'i', 's' }, '<C-L>', function()
      ls.jump(1)
      print 'LLLL'
    end, { silent = true })
    vim.keymap.set({ 'i', 's' }, '<C-J>', function()
      ls.jump(-1)
    end, { silent = true })
    vim.keymap.set({ 'i', 's' }, '<C-E>', function()
      if ls.choice_active() then
        ls.change_choice(1)
      end
    end, { silent = true })

    require('luasnip.loaders.from_lua').load {
      paths = os.getenv 'LOCALAPPDATA' .. '/nvim/lua/snippets',
      -- paths = '%localappdata%/nvim/lua/snippets',
      -- paths = vim.fn.stdpath 'config' .. '/lua/snippets',
    }
  end,
}
