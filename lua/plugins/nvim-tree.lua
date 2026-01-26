return {
  'nvim-tree/nvim-tree.lua',
  version = '*',
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('nvim-tree').setup {
      filters = { custom = { '^.git$', '.uid$', '.tmp$' } },
    }
    vim.keymap.set('n', '<leader>cd', function()
      vim.cmd ':NvimTreeOpen'
    end, { desc = 'Open file explorer' })
  end,
}
