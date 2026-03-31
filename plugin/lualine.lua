vim.pack.add({"https://github.com/nvim-lualine/lualine.nvim"})
require('lualine').setup({
    options = {
        icons_enabled = true,
        theme = 'auto',
        -- theme = 'tokyonight',
        -- component_separators = { left = '', right = '' },
        -- section_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        -- component_separators = { left = '', right = '' },
        component_separators = { left = '|', right = '|' },
        -- section_separators = '',
        always_show_tabline = false,
        -- disabled_filetypes = {
        --   statusline = {},
        --   winbar = {},
        --   tabline = {}
        -- },
        always_divide_middle = false,
        globalstatus = true, -- single statusline
    },
    winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = {},
        lualine_y = { "filetype" },
        lualine_z = {}
    },
    inactive_winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
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
        lualine_b = { 'branch' },
        lualine_c = { "buffers" },
        lualine_x = { 'diff' },
        lualine_y = { 'progress', 'location' },
        lualine_z = { 'tabs' },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
    },
})
