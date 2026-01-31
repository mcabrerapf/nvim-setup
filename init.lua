require 'config.options'
require 'config.keybinds'
require 'config.autocmds'
require 'config.lazy'

vim.fn.setenv('GODOT_PROJECTS_PATH', 'F:/godot/projects/')
vim.fn.setenv('GODOT_EXE_PATH', 'F:/godot/Godot.exe')
vim.fn.setenv('GODOT_SERVER_PORT', '127.0.0.1:6004')
vim.fn.setenv('NOTES_DIR_PATH', vim.fn.stdpath 'config' .. '/notes')
vim.fn.setenv('SESSIONS_DIR_PATH', vim.fn.stdpath 'config' .. '/sessions')
if vim.fn.isdirectory(vim.env.NOTES_DIR_PATH) == 0 then
  vim.fn.mkdir(vim.env.NOTES_DIR_PATH, 'p')
end
if vim.fn.isdirectory(vim.env.SESSIONS_DIR_PATH) == 0 then
  vim.fn.mkdir(vim.env.SESSIONS_DIR_PATH, 'p')
end
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)
-- NOTE: Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

vim.api.nvim_set_hl(0, 'CustomHighlightedText', { fg = '#f01df7' })
vim.api.nvim_set_hl(0, 'CustomHighlight', { bg = '#f01df7', fg = 'white' })
-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = { 'gdscript', 'gdshader', 'godot_resource' },
--   callback = function()
--     vim.treesitter.start()
--     vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
--     vim.wo[0][0].foldmethod = 'expr'
--     vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
--   end,
-- })
