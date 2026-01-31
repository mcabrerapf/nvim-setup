return {
  'navarasu/onedark.nvim',
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    require('onedark').setup {
      style = 'deep',
      code_style = {
        comments = 'italic',
        keywords = 'bold,italic',
        functions = 'bold',
        strings = 'none',
        variables = 'bold',
      },
      transparent = true,
      term_colors = true,
    }
    require('onedark').load()
    vim.api.nvim_set_hl(0, 'Visual', { link = 'CustomHighlight' })
    vim.api.nvim_set_hl(0, 'IncSearch', { link = 'CustomHighlight' })
    vim.api.nvim_set_hl(0, 'MiniFilesTitleFocused', { link = 'CustomHighlightedText' })
    -- vim.api.nvim_set_hl(0, '@type', { fg = 'red' })
  end,
}
