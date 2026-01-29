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
