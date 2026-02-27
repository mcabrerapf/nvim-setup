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
require 'config.hl_groups'
