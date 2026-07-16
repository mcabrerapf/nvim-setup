local gh = require("utils.gh")
vim.pack.add({ gh("navarasu/onedark.nvim") })
require('onedark').setup {
    style = 'darker', -- **Options:**  dark, darker, cool, deep, warm, warmer, light
    code_style = {
        comments = 'italic',
        -- keywords = 'bold,italic',
        -- functions = 'bold',
        -- strings = 'none',
        -- variables = 'bold',
    },
    transparent = true,
    term_colors = true,
    toggle_style_key = "<leader>ts",
    toggle_style_list = { 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' }, -- List of styles to toggle between
}
require('onedark').load()
-- NOTE: This highlights need to be moved whenever the theme changes to so they override the theme highlights
-- vim.api.nvim_set_hl(0, 'CustomHighlightedText', { fg = '#04f49c', bg = 'NONE', bold = true })
-- vim.api.nvim_set_hl(0, 'CustomHighlight', { fg = 'black', bg = '#04f49c'})
vim.api.nvim_set_hl(0, 'FirstNameHighlight', { fg = '#04f49c', bg = 'NONE', bold = true })
vim.api.nvim_set_hl(0, 'TodoComment', { fg = 'black', bg = '#fc16b3', bold = true }) -- TODO:
vim.api.nvim_set_hl(0, 'NoteComment', { fg = 'black', bg = '#16e9fc', bold = true }) -- NOTE:
vim.api.nvim_set_hl(0, 'BugComment', { fg = 'black', bg = '#fc1e16', bold = true })  -- BUG:
vim.api.nvim_set_hl(0, 'HackComment', { fg = 'black', bg = '#ffa500', bold = true })  -- HACK:
--
-- vim.api.nvim_set_hl(0, 'Visual', { link = 'CustomHighlight' })
-- vim.api.nvim_set_hl(0, 'IncSearch', { link = 'CustomHighlight' })
-- vim.api.nvim_set_hl(0, 'CurSearch', { fg = '#ffffff', bg = '' })
-- vim.api.nvim_set_hl(0, 'Search', { fg = '#ffffff', bg = '' })
-- vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#ffffff', bg = '' })
-- vim.api.nvim_set_hl(0, 'Folded', { fg = '#ffffff', bg = '' })
-- vim.api.nvim_set_hl(0, 'LineNr', { fg = '#ffffff', bg = '' })
-- vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#ffffff', bg = '' })
-- Floating windows
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = "NONE" })
vim.api.nvim_set_hl(0, 'FloatTitle', { fg = '#16e9fc', bg = vim.api.nvim_get_hl(0, { name = 'NormalFloat' }).bg,  bold = true })
vim.api.nvim_set_hl(0, 'FloatBorder', { fg = '#16e9fc', bg = vim.api.nvim_get_hl(0, { name = 'NormalFloat' }).bg,  bold = true })
vim.api.nvim_set_hl(0, 'FloatFooter', { fg = '#16e9fc', bg = vim.api.nvim_get_hl(0, { name = 'NormalFloat' }).bg,  bold = true })
-- mini.files
vim.api.nvim_set_hl(0, 'MiniFilesNormal', { bg = "NONE" })
vim.api.nvim_set_hl(0, 'MiniFilesTitle', { link = 'FloatTitle' })
vim.api.nvim_set_hl(0, 'MiniFilesTitleFocused', { fg = '#ffffff', bg = vim.api.nvim_get_hl(0, { name = 'NormalFloat' }).bg,  bold = true })
vim.api.nvim_set_hl(0, 'MiniFilesBorder', { link = 'FloatBorder' })
-- mini.pick
vim.api.nvim_set_hl(0, 'MiniPickNormal', { bg = "NONE" })
vim.api.nvim_set_hl(0, 'MiniPickHeader', { link = 'FloatTitle' })
vim.api.nvim_set_hl(0, 'MiniPickBorder', { link = 'FloatBorder' })
vim.api.nvim_set_hl(0, 'MiniPickMatchMarked', { fg = '#000000', bg = '#ffffff' })

vim.api.nvim_set_hl(0, 'StatuslineGitAdd', { fg = '#ff1111', bg = '#ffffff' })
-- status line
local hl = function(group)
	return vim.api.nvim_get_hl(0, {
		name = group,
		link = false,
		create = false,
	})
end

local set_hl_groups = function()
	local base = hl("StatusLine")

	for group, opts in pairs({
		ModeNormal = { fg = base.bg, bg = hl("StatusLine").fg },
		ModePending = { fg = base.bg, bg = hl("Comment").fg },
		ModeVisual = { fg = base.bg, bg = hl("SpecialKey").fg },
		ModeInsert = { fg = base.bg, bg = hl("DiffAdded").fg },
		ModeCommand = { fg = base.bg, bg = hl("Number").fg },
		ModeReplace = { fg = base.bg, bg = hl("Constant").fg },
		Bold = { fg = base.fg, bg = base.bg, bold = true },
		Dim = { fg = hl("LineNr").fg, bg = base.bg },
	}) do
		group = "StatusLine" .. group
		vim.api.nvim_set_hl(0, group, opts)
		opts.fg, opts.bg = opts.bg, opts.fg
		vim.api.nvim_set_hl(0, group .. "Inverted", opts)
	end
end
-- Compile and apply our custom highlights
set_hl_groups()
-- Re-compile statusline colours when the colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("my_statusline", {}),
	desc = "Re-apply statusline highlights on colorscheme change",
	callback = set_hl_groups,
})
