return {
  -- "folke/tokyonight.nvim",
  -- lazy = false,
  -- priority = 1000,
  -- -- opts = {
  -- --   transparent = true,
  -- --   style = 'storm',
  -- --   dim_inactive = true, -- dims inactive windows
  -- --   lualine_bold = false,
  -- -- },
  -- config = function()
  --   require("tokyonight.colors").setup({
  --     style = 'moon',      -- storm, moon, night, and day.
  --     -- transparent = false,
  --     dim_inactive = true, -- dims inactive windows
  --     lualine_bold = false,
  --     styles = {
  --       -- Style to be applied to different syntax groups
  --       -- Value is any valid attr-list value for `:help nvim_set_hl`
  --       comments = { italic = true },
  --       keywords = { italic = true },
  --       functions = {},
  --       variables = {},
  --       -- Background styles. Can be "dark", "transparent" or "normal"
  --       sidebars = "dark", -- style for sidebars, see below
  --       floats = "dark",   -- style for floating windows
  --     },
  --   })
  --   -- vim.g.tokyonight_style = "night" -- options: "storm", "night", "day", "moon"
  --   -- vim.g.tokyonight_italic_functions = true
  --   -- vim.g.tokyonight_italic_comments = true
  --   vim.g.tokyonight_transparent = true -- set true if you want a transparent background
  --
  --   -- Load the colorscheme
  --   vim.cmd [[colorscheme tokyonight]]
  -- end
  ---------------
  'navarasu/onedark.nvim',
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    require('onedark').setup {
      style = 'warmer', -- **Options:**  dark, darker, cool, deep, warm, warmer, light
      code_style = {
        comments = 'none',
        keywords = 'bold,italic',
        functions = 'bold',
        strings = 'none',
        variables = 'bold',
      },
      transparent = true,
      term_colors = true,
      toggle_style_key = "<leader>ts",
      toggle_style_list = { 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' }, -- List of styles to toggle between
    }
    require('onedark').load()
  end,
}
