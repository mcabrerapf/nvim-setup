require 'utils.load-env' ()

if vim.fn.isdirectory(vim.env.NOTES_DIR_PATH) == 0 then
  vim.fn.mkdir(vim.env.NOTES_DIR_PATH, 'p')
end
if vim.fn.isdirectory(vim.env.SESSIONS_DIR_PATH) == 0 then
  vim.fn.mkdir(vim.env.SESSIONS_DIR_PATH, 'p')
end

require 'config.options'
require 'config.keymaps'
require 'config.autocmds'
require 'config.lazy'
-- NOTE: Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)
-- harsh pink '#f01df7'
vim.api.nvim_set_hl(0, 'CustomHighlightedText', { fg = '#04f49c', bg = 'NONE', bold = true })
vim.api.nvim_set_hl(0, 'CustomHighlight', { bg = '#04f49c', fg = 'black' })
