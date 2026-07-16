vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })
vim.keymap.set('t', '<Esc><Esc>', '<c-\\><c-n>', { desc = 'Close terminal' }) -- NOTE: Easy way to close terminal
vim.keymap.set('n', '<M-s>', ':w<CR>', { desc = "Save" })
vim.keymap.set('n', '<C-s>', 's', { desc = "S mode" })
vim.keymap.set('n', '<M-h>', '^', { desc = 'Move to first character in line' })
vim.keymap.set('n', '<M-l>', 'g_', { desc = 'Move to last character in line' })
vim.keymap.set('n', '<M-.>', '<C-^>', { desc = 'Switch to last buffer' })
vim.keymap.set('n', '<leader><M-d>', vim.diagnostic.setloclist, { desc = 'Send diagnostics to qflist' })

vim.keymap.set('n', '<leader>h', function()
    local cword = vim.fn.expand('<cword>')
    if cword == '' then return end
    vim.cmd('h ' .. cword)
end, { desc = 'Find help for cword' })

vim.keymap.set('n', '<leader>H', function()
    local cword = vim.fn.expand('<cword>')
    if cword == '' then return end
    vim.cmd('lh ' .. cword)
    vim.cmd 'lwindow'
end, { desc = 'Grep search help for cword' })


vim.keymap.set("n", "<M-q>", function()
    local current = vim.api.nvim_get_current_buf()
    local wins = vim.fn.win_findbuf(current)
    local targetbuf
    local alt = vim.fn.bufnr("#")

    if alt ~= -1 and vim.api.nvim_buf_is_loaded(alt) then
        targetbuf = alt
    end
    -- iterate through buffers and get the last one that points to a file
    if targetbuf == nil then
        local buffers = vim.fn.getbufinfo({ buflisted = 1 })
        for i = #buffers, 1, -1 do
            local buf = buffers[i].bufnr

            if buf ~= current then
                local name = vim.api.nvim_buf_get_name(buf)

                if name ~= "" then
                    targetbuf = buf
                    break
                end
            end
        end
    end
    if targetbuf == nil then
        targetbuf = vim.api.nvim_create_buf(true, false)
    end
    vim.api.nvim_set_current_buf(targetbuf)

    -- NOTE: Search windows and replace buf if its being deleted
    for _, value in pairs(wins) do
        if vim.api.nvim_win_get_buf(value) == current then
            vim.api.nvim_win_set_buf(value, targetbuf)
        end
    end
    vim.api.nvim_buf_delete(current, { force = false })
end, { desc = "Delete current buffer without closing window" })

vim.keymap.set('n', '<leader><M-r>', function ()
    local sessionPath = vim.env.SESSIONS_DIR_PATH .. '/' or ''
    sessionPath = sessionPath .. 'restart_sesh.vim'
    vim.cmd(':mksession! ' .. sessionPath .. ' | restart source ' .. sessionPath)
end, { desc = 'Restart neovim and restore current session' })
