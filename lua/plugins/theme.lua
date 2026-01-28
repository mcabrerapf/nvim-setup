return {
  'navarasu/onedark.nvim',
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    require('onedark').setup {
      style = 'deep',
      code_style = {
        comments = 'italic',
        keywords = 'none',
        functions = 'none',
        strings = 'none',
        variables = 'bold',
      },
      transparent = true,
      term_colors = true,
      -- style = 'darker',
    }
    require('onedark').load()
    -- vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
    -- vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
    --   vim.api.nvim_create_autocmd({ 'WinEnter', 'BufWinEnter' }, {
    --     callback = function()
    --       vim.cmd [[
    --       	"hi Normal guibg=#282c34   " active window background
    --       	hi NormalNC guibg=#1c1c1c " inactive window background
    -- "hi WinSeparator guifg=#ff8800
    --       ]]
    --     end,
    --   })
    -- optional: update when leaving a window
    -- vim.api.nvim_create_autocmd('WinLeave', {
    --   callback = function()
    --     vim.cmd [[
    --     	hi NormalNC guibg=#1c1c1c " inactive window background
    --     ]]
    --   end,
    -- })
  end,
}

-- return {
--   'scottmckendry/cyberdream.nvim',
--   lazy = false,
--   priority = 1000,
-- }

-- return {
--   -- You can easily change to a different colorscheme.
--   -- Change the name of the colorscheme plugin below, and then
--   -- change the command in the config to whatever the name of that colorscheme is.
--   --
--   -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
--   'folke/tokyonight.nvim',
--   priority = 1000, -- Make sure to load this before all the other start plugins.
--   config = function()
--     ---@diagnostic disable-next-line: missing-fields
--     require('tokyonight').setup {
--       styles = {
--         comments = { italic = false }, -- Disable italics in comments
--       },
--     }
--
--     -- Load the colorscheme here.
--     -- Like many other themes, this one has different styles, and you could load
--     -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
--     vim.cmd.colorscheme 'tokyonight-night'
--   end,
-- }
