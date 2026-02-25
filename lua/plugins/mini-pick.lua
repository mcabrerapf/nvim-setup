local win_size = function()
  local height = math.floor(0.35 * vim.o.lines)
  local width = math.floor(0.75 * vim.o.columns)

  local config = {
    anchor = 'NE',
    height = height,
    width = width,
    border = 'rounded',
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
      },
      mappings = {
        -- toggle_info    = '<C-k>',
        -- toggle_preview = '<C-p>',
        -- scroll_right = '<C-l>',
        -- stop = '<M-q>',
        stop = '<M-q>',
        choose = '<M-l>',
        choose_in_vsplit = '<M-v>',
        move_down = '<M-j>',
        move_up = '<M-k>',
        mark = '<M-x>',
        choose_marked = '<M-n>',
      },
      sources = {
        -- buffers = {
        --   sort = function(a, b)
        --     return a.info.lastused > b.info.lastused
        --   end,
        -- },
      },
    }

    vim.keymap.set('n', '<leader>ss', function()
      pick.builtin.files(nil, {
        source = {
          name = 'Search files',
          show = filename_first,
        },
      })
    end, { desc = 'Do [s]earch' })
    --
    vim.keymap.set('n', '<leader>sS', function()
      pick.builtin.grep_live(nil, {
        source = {
          name = 'Grep search',
        },
      })
    end, { desc = 'Do grep [S]earch' })
    --
    vim.keymap.set('n', '<leader>sw', function()
      local cword = vim.fn.expand("<cword>")
      pick.builtin.grep({ pattern = cword }, { source = { name = cword } })
    end, { desc = "Grep [w]ord" })
    --
    vim.keymap.set('v', '<leader>s', function()
      vim.cmd("normal! y")
      local text = vim.fn.getreg('"')
      pick.builtin.grep({ pattern = text }, { source = { name = text } })
    end, { desc = "Grep [s]election" })
    --
    vim.keymap.set('n', '<leader>sv', function()
      pick.builtin.files(nil, {
        source = {
          name = 'Search nvim files',
          cwd = vim.fn.stdpath 'config',
          show = filename_first,
        },
      })
    end, { desc = 'Search files in neo[v]im config' })
    --
    vim.keymap.set('n', '<leader>sb', function()
      pick.builtin.buffers()
    end, { desc = 'Search in [b]uffers' })
    --
    vim.keymap.set('n', '<leader>sh', function()
      pick.builtin.help()
    end, { desc = 'Search [h]elp tags' })
    --
    vim.keymap.set('n', '<leader>sr', function()
      pick.builtin.resume()
    end, { desc = '[r]esume last search' })
  end,
}
