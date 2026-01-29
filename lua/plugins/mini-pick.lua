return {
  'nvim-mini/mini.pick',
  config = function()
    local pick = require 'mini.pick'
    pick.setup {
      window = {
        config = {
          border = 'rounded',
          height = 15,
        },
      },
      sources = {
        buffers = {
          sort = function(a, b)
            return a.info.lastused > b.info.lastused
          end,
        },
      },
    }

    vim.keymap.set('n', '<leader>ss', function()
      pick.builtin.files()
    end, { desc = 'Do [s]earch' })

    vim.keymap.set('n', '<leader>sS', function()
      pick.builtin.grep_live()
    end, { desc = 'Do grep [S]earch' })

    vim.keymap.set('n', '<leader>sn', function()
      pick.builtin.files(nil, { source = { cwd = vim.fn.stdpath 'config' } })
    end, { desc = '[s]earch files in neovim config' })

    vim.keymap.set('n', '<leader>s<leader>', function()
      pick.builtin.buffers()
    end, { desc = 'Search in buffers' })
    -- vim.keymap.set('n', '<leader>fh', function()
    --   pick.builtin.help()
    -- end, { desc = 'Help tags' })
  end,
}
