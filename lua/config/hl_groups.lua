vim.api.nvim_set_hl(0, 'CustomHighlightedText', { fg = '#04f49c', bg = 'NONE', bold = true })
vim.api.nvim_set_hl(0, 'CustomHighlight', { bg = '#04f49c', fg = 'black' })
-- TODO:
-- NOTE:
-- BUG:
vim.api.nvim_set_hl(0, 'TodoComment', { fg = 'black', bg = '#fc16b3', bold = true })
vim.api.nvim_set_hl(0, 'NoteComment', { fg = 'black', bg = '#16e9fc', bold = true })
vim.api.nvim_set_hl(0, 'BugComment', { fg = 'black', bg = '#fc1e16', bold = true })
-- vim.api.nvim_set_hl(0, 'Visual', { link = 'CustomHighlight' })
vim.api.nvim_set_hl(0, 'IncSearch', { link = 'CustomHighlight' })
vim.api.nvim_set_hl(0, 'MiniFilesTitleFocused', { link = 'CustomHighlightedText' })
