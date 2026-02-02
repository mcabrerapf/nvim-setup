return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- optional but nice
    event = 'VeryLazy',
    config = function()
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'auto',
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          -- component_separators = '|',
          -- section_separators = '',
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          always_divide_middle = true,
          globalstatus = false, -- single statusline
        },
        sections = {
          lualine_a = {
            {
              'mode',
              fmt = function()
                return vim.fs.basename(vim.fn.getcwd())
              end,
              color = { gui = 'bold' },
            },
          },
          lualine_b = {
            'branch',
            'diff',
          },
          lualine_c = {
            {
              'filename',
              file_status = true,
              newfile_status = false,
              symbols = {
                modified = '[+]',
                readonly = '[-]',
                unnamed = '[No Name]',
                newfile = '[New]',
              },
              color = { fg = '#a9b1d6' },
            },
          },
          lualine_x = { 'encoding' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = {},
      }
    end,
  },
}
