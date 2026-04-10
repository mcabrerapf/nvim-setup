local gh = require("utils.gh")
vim.pack.add({ gh("navarasu/onedark.nvim") })
require('onedark').setup {
    style = 'darker', -- **Options:**  dark, darker, cool, deep, warm, warmer, light
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
-- vim.api.nvim_set_hl(0, 'CustomHighlightedText', { fg = '#04f49c', bg = 'NONE', bold = true })
vim.api.nvim_set_hl(0, 'CustomHighlight', { fg = 'black', bg = '#04f49c'})
vim.api.nvim_set_hl(0, 'FirstNameHighlight', { fg = '#04f49c', bg = 'NONE', bold = true })
vim.api.nvim_set_hl(0, 'TodoComment', { fg = 'black', bg = '#fc16b3', bold = true }) -- TODO:
vim.api.nvim_set_hl(0, 'NoteComment', { fg = 'black', bg = '#16e9fc', bold = true }) -- NOTE:
vim.api.nvim_set_hl(0, 'BugComment', { fg = 'black', bg = '#fc1e16', bold = true })  -- BUG:
--
vim.api.nvim_set_hl(0, 'Visual', { link = 'CustomHighlight' })
vim.api.nvim_set_hl(0, 'IncSearch', { link = 'CustomHighlight' })
vim.api.nvim_set_hl(0, 'CurSearch', { fg = '#ffffff', bg = '' })
vim.api.nvim_set_hl(0, 'Search', { fg = '#ffffff', bg = '' })
vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#ffffff', bg = '' })
vim.api.nvim_set_hl(0, 'Folded', { fg = '#ffffff', bg = '' })
-- vim.api.nvim_set_hl(0, 'LineNr', { fg = '#ffffff', bg = '' })
vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#ffffff', bg = '' })
-- Floating windows
-- vim.api.nvim_set_hl(0, 'NormalFloat', { fg = '#16e9fc', bg = 2532756 })
vim.api.nvim_set_hl(0, 'FloatTitle', { fg = '#16e9fc', bg = vim.api.nvim_get_hl(0, { name = 'NormalFloat' }).bg,  bold = true })
vim.api.nvim_set_hl(0, 'FloatBorder', { fg = '#16e9fc', bg = vim.api.nvim_get_hl(0, { name = 'NormalFloat' }).bg,  bold = true })
vim.api.nvim_set_hl(0, 'FloatFooter', { fg = '#16e9fc', bg = vim.api.nvim_get_hl(0, { name = 'NormalFloat' }).bg,  bold = true })
-- mini files
vim.api.nvim_set_hl(0, 'MiniFilesTitle', { fg = '#ffffff', bg = vim.api.nvim_get_hl(0, { name = 'NormalFloat' }).bg })
vim.api.nvim_set_hl(0, 'MiniFilesTitleFocused', { fg = '#16e9fc', bg = vim.api.nvim_get_hl(0, { name = 'NormalFloat' }).bg,  bold = true })
