vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.shell = 'cmd'
-- NOTE: Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true
vim.opt.termguicolors = true
-- NOTE: Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- NOTE: Make line numbers default
vim.o.number = true
vim.o.relativenumber = true
-- NOTE: Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'
-- NOTE: Don't show the mode, since it's already in the status line
vim.o.showmode = false
vim.o.breakindent = true
-- NOTE: Keep undo history even after vim closes
vim.o.undofile = true
-- NOTE: Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true
-- NOTE: Keep signcolumn on by default
vim.o.signcolumn = 'yes'
-- NOTE: Decrease update time
vim.o.updatetime = 250
-- NOTE:Decrease mapped sequence wait time
-- vim.o.timeoutlen = 300
-- NOTE:Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.eadirection = 'ver'
-- NOTE: Sets how neovim will display certain whitespace characters in the editor.
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
-- NOTE: Preview substitutions live, as you type!
vim.o.inccommand = 'split'
-- NOTE: Show which line your cursor is on
vim.o.cursorline = true
-- NOTE: Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10
-- NOTE: if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true
