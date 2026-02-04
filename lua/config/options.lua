vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.loaded_netrw = 1 -- Disable netrw if any other explorer is loaded
vim.g.loaded_netrwPlugin = 1
vim.g.have_nerd_font = true --Set to true if you have a Nerd Font installed and selected in the terminal
-- vim.o.shell = 'cmd'
vim.o.autoread = true
vim.o.termguicolors = true
vim.o.winborder = 'rounded'
vim.o.number = true -- Show line numbers
vim.o.relativenumber = true
vim.o.mouse = 'a' -- enable mouse
vim.o.showmode = false -- dont show mode if using lualine or something else
-- vim.o.wrap = false -- disable wrapping
vim.o.breakindent = true -- text breaks up if reaches end of screen
vim.o.undofile = true -- undo history remains after closing
vim.o.ignorecase = true -- ignore case unless forced with command or upper case in text
vim.o.smartcase = true
vim.o.signcolumn = 'yes' -- When and how to draw the signcolumn
vim.o.updatetime = 250 -- Decrease update time
vim.o.timeoutlen = 300 -- Decrease mapped sequence wait time
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.eadirection = 'ver' -- Tells when the 'equalalways' option applies
vim.o.list = true -- Sets how neovim will display certain whitespace characters in the editor.
vim.o.inccommand = 'split' -- Preview substitutions live, as you type
vim.o.cursorline = true -- Show which line your cursor is on
vim.o.scrolloff = 10 -- Minimal number of screen lines to keep above and below the cursor.
vim.o.confirm = true -- Raise a dialog asking if you wish to save the current file(s)
vim.opt.foldenable = false -- set folds to open when opening file
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.guicursor = { -- cursor blink if using wezterm need to set its default blink rate as well
  'n-v-c:block',
  'i-ci-ve:ver25',
  'r-cr:hor20',
  'o:hor50',
  'a:blinkon400-blinkoff400-blinkwait400',
}
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },

  -- Can switch between these as you prefer
  virtual_text = true, -- Text shows up at the end of the line
  virtual_lines = false, -- Teest shows up underneath the line, with virtual lines

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = { float = true },
}
