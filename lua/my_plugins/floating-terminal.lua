local create_floating_window = require 'utils.create-floating-window'
local M = {
    buf = -1,
    win = -1,
}

local function setup_buffer()
    if vim.api.nvim_buf_is_valid(M.buf) then return end
    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].bufhidden = "hide"
    vim.bo[buf].buflisted = false
    M.buf = buf
end

local toggle_terminal = function()
    if not vim.api.nvim_win_is_valid(M.win) then
        setup_buffer()
        M.win = create_floating_window { buf = M.buf, winfixbuf = false }
        if vim.bo[M.buf].buftype ~= 'terminal' then
            vim.cmd.terminal()
        end
        vim.cmd 'startinsert'
        vim.keymap.set({ 'n', 'i', 't' }, '<M-q>', function()
            vim.api.nvim_win_hide(M.win)
        end, { buffer = true })
    else
        vim.api.nvim_win_hide(M.win)
    end
end

local function create_commands()
    vim.api.nvim_create_user_command('FloTermToggle', toggle_terminal, {})
end

local function create_keymaps()
    vim.keymap.set('n', '<leader>tt', ':FloTermToggle<CR>', { desc = 'Toggle floating terminal', silent = true, })
end

M.setup = function()
    create_commands()
    create_keymaps()
end

return M
