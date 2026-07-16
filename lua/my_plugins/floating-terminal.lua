local create_floating_window = require 'utils.create-floating-window'
local M = {}

local function setup_buffer()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].buflisted = false
    return buf
end

local toggle_terminal = function()
        local buf = setup_buffer()
        local win = create_floating_window { buf = buf, winfixbuf = false }
        if vim.bo[buf].buftype ~= 'terminal' then
            vim.cmd.terminal()
        end
        vim.cmd 'startinsert'
        vim.api.nvim_create_autocmd(
            'WinClosed',
            {
                desc = "delete current terminal buff",
                buf = buf,
                callback = function ()
                    vim.api.nvim_buf_delete(buf, { force = true })
                end
            }
        )
        vim.keymap.set({ 'n', 'i', 't' }, 'q', function()
            vim.api.nvim_win_hide(win)
        end, { buffer = buf })
        vim.keymap.set({ 'n', 'i', 't' }, '<M-q>', function()
            vim.api.nvim_win_hide(win)
        end, { buffer = buf })
end

local function create_commands()
    vim.api.nvim_create_user_command('FloTermToggle', toggle_terminal, {})
end

local function create_keymaps()
    vim.keymap.set('n', '<M-t>', ':FloTermToggle<CR>', { desc = 'Toggle floating terminal', silent = true, })
end

M.setup = function()
    create_commands()
    create_keymaps()
end

return M
