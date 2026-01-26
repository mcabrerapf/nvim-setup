return {
  -- Harpoon
  'ThePrimeagen/harpoon',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    local harpoonui = require 'harpoon.ui'
    local harpoonmark = require 'harpoon.mark'
    vim.keymap.set('n', '<leader>hh', function()
      harpoonui.toggle_quick_menu()
    end, { desc = 'Open [H]arpoon Menu' })

    vim.keymap.set('n', '<leader>h1', function()
      harpoonui.nav_file(1)
    end, { desc = 'Go to file [1]' })

    vim.keymap.set('n', '<leader>h2', function()
      harpoonui.nav_file(2)
    end, { desc = 'Go to file [2]' })

    vim.keymap.set('n', '<leader>h3', function()
      harpoonui.nav_file(3)
    end, { desc = 'Go to file [3]' })

    vim.keymap.set('n', '<leader>h4', function()
      harpoonui.nav_file(4)
    end, { desc = 'Go to file [4]' })

    vim.keymap.set('n', '<leader>ha', function()
      harpoonmark.add_file()
    end, { desc = '[A]dd file to Harpoon' })
  end,
}
