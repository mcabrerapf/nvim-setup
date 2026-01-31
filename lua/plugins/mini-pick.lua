local win_size = function()
  local height = math.floor(0.35 * vim.o.lines)
  local width = math.floor(0.75 * vim.o.columns)

  local config = {
    anchor = 'NE',
    height = height,
    width = width,
    border = 'double',
    -- border = 'rounded',
    row = math.floor(0.55 * vim.o.lines),
    col = math.floor(0.88 * vim.o.columns),
  }
  return config
end

return {
  'nvim-mini/mini.pick',
  config = function()
    local filename_first = require 'utils.filename-first'
    local pick = require 'mini.pick'
    pick.setup {
      window = {
        config = win_size,
        -- config = {
        --   border = 'rounded',
        --   height = 15,
        -- },
      },
      mappings = {
        -- toggle_info    = '<C-k>',
        -- toggle_preview = '<C-p>',
        -- scroll_right = '<C-l>',
        choose_in_vsplit = '<C-l>',
        move_down = '<C-j>',
        move_up = '<C-k>',
        choose_marked = '<C-n>',
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
      pick.builtin.files(nil, {
        source = {
          -- filter = function(path)
          --   print('path to filter ' .. path)
          --   return not path:match '%.(uid|tscn)$'
          --   -- return not (path:match '%.uid$' or path:match '%.tscn$')
          -- end,
          show = filename_first,
        },
      })
    end, { desc = 'Do [s]earch' })

    vim.keymap.set('n', '<leader>sS', function()
      pick.builtin.grep_live()
    end, { desc = 'Do grep [S]earch' })

    vim.keymap.set('n', '<leader>sn', function()
      pick.builtin.files(nil, {
        source = {
          cwd = vim.fn.stdpath 'config',
          show = filename_first,
        },
      })
    end, { desc = '[s]earch files in neovim config' })

    vim.keymap.set('n', '<leader>s<leader>', function()
      pick.builtin.buffers()
    end, { desc = 'Search in buffers' })
    vim.keymap.set('n', '<leader>sh', function()
      pick.builtin.help()
    end, { desc = 'Help tags' })
  end,
}
