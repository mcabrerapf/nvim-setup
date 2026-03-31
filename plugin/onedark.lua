
vim.pack.add({"https://github.com/navarasu/onedark.nvim"})

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

-- NOTE: This highlights need to be moved whenever the theme changes to so they override the theme highlights
vim.api.nvim_set_hl(0, 'CustomHighlightedText', { fg = '#04f49c', bg = 'NONE', bold = true })
vim.api.nvim_set_hl(0, 'CustomHighlight', { bg = '#04f49c', fg = 'black' })
-- TODO:
-- NOTE:
-- BUG:
vim.api.nvim_set_hl(0, 'TodoComment', { fg = 'black', bg = '#fc16b3', bold = true })
vim.api.nvim_set_hl(0, 'NoteComment', { fg = 'black', bg = '#16e9fc', bold = true })
vim.api.nvim_set_hl(0, 'BugComment', { fg = 'black', bg = '#fc1e16', bold = true })
vim.api.nvim_set_hl(0, 'Visual', { link = 'CustomHighlight' })
vim.api.nvim_set_hl(0, 'IncSearch', { link = 'CustomHighlight' })
vim.api.nvim_set_hl(0, 'FirstNameHighlight', { fg = '#04f49c', bg = 'NONE', bold = true })
