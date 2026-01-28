return {
  'nvim-tree/nvim-tree.lua',
  version = '*',
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('nvim-tree').setup {
      filters = { custom = { '^.git$', '.uid$', '.tmp$', '.import$', '.tscn', '.DS_Store' } },
      update_focused_file = {
        -- enable = true, -- updates NvimTree to focus the current file
        update_cwd = true, -- update Neovim's cwd when file changes
      },
      -- sync_root_with_cwd = true, -- sync NvimTree root with cwd
      -- respect_buf_cwd = true,
    }
    vim.keymap.set('n', '<leader>cd', function()
      vim.cmd ':NvimTreeOpen'
    end, { desc = 'Open file explorer' })
  end,
}
