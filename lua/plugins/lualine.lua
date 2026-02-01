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
          globalstatus = true, -- single statusline
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = {
            'branch',
            'diff',
            {
              function()
                return vim.fs.basename(vim.fn.getcwd())
              end,
              color = { gui = 'bold' },
            },
          },
          lualine_c = {
            {
              function()
                return vim.fn.expand '%:t'
              end,
              color = { fg = '#04f49c', gui = 'bold' },
            },
            -- {
            --   function()
            --     local file = vim.fn.expand '%:t'
            --     if file == '' then
            --       return vim.fn.fnamemodify(vim.uv.cwd(), ':t')
            --     end
            --     return vim.fn.fnamemodify(vim.uv.cwd(), ':t')
            --   end,
            --   color = { fg = '#a9b1d6' },
            -- },
          },
          -- lualine_c = { { 'filename', path = 1 } },
          lualine_x = { 'encoding', 'filetype' },
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
