local gh = require("utils.gh")
vim.pack.add({ gh("nvim-mini/mini.pick") })
local filename_first = require 'utils.filename-first'
local win_config = function()
  local height = math.floor(0.35 * vim.o.lines)
  local width = math.floor(0.75 * vim.o.columns)

  local config = {
    anchor = 'NE',
    height = height,
    width = width,
    border = 'rounded',
    row = math.floor(0.55 * vim.o.lines),
    col = math.floor(0.88 * vim.o.columns),
  }
  return config
end

local pick = require('mini.pick')
pick.setup({
    window = {
        config = win_config,
    },
    mappings = {
        -- toggle_info    = '<C-k>',
        -- toggle_preview = '<C-p>',
        -- scroll_right = '<C-l>',
        stop = '<M-q>',
        choose = '<M-l>',
        choose_in_vsplit = '<M-v>',
        move_down = '<M-j>',
        move_up = '<M-k>',
        mark = '<M-x>',
        choose_marked = '<M-n>',
    },
})
-- Keymaps
vim.keymap.set('n', '<leader>ss', function()
    pick.builtin.files(nil, {
        source = {
            name = 'Search files',
            show = filename_first,
        },
    })
end, { desc = 'Do search' })
--
vim.keymap.set('n', '<leader>sS', function()
    pick.builtin.grep_live(nil, {
        source = {
            name = 'Grep search',
        },
    })
end, { desc = 'Do grep search' })
--
vim.keymap.set('n', '<leader>sw', function()
    local cword = vim.fn.expand("<cword>")
    pick.builtin.grep({ pattern = cword }, { source = { name = cword } })
end, { desc = "Grep word" })
--
vim.keymap.set('v', '<leader>s', function()
    vim.cmd("normal! y")
    local text = vim.fn.getreg('"')
    pick.builtin.grep({ pattern = text }, { source = { name = text } })
end, { desc = "Grep selection" })
--
vim.keymap.set('n', '<leader>sv', function()
    pick.builtin.files(nil, {
        source = {
            name = 'Search nvim files',
            cwd = vim.fn.stdpath 'config',
            show = filename_first,
        },
    })
end, { desc = 'Search files in nvim config' })
--
vim.keymap.set('n', '<leader>sb', function()
    pick.builtin.buffers()
end, { desc = 'Search in buffers' })
--
vim.keymap.set('n', '<leader>sh', function()
    pick.builtin.help()
end, { desc = 'Search help tags' })
--
vim.keymap.set('n', '<leader>sr', function()
    pick.builtin.resume()
end, { desc = 'Resume last search' })
