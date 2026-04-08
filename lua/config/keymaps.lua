vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })
vim.keymap.set('i', '<C-c>', '<esc>', { desc = 'Esc' })
vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>', { desc = 'Close terminal' }) -- NOTE: Easy way to close terminal

vim.keymap.set('n', '<M-j>', '<C-d>', { desc = 'Scroll half screen Down' })
vim.keymap.set('n', '<M-k>', '<C-u>', { desc = 'Scroll half screen Up' })
vim.keymap.set('n', '<M-l>', 'g_', { desc = 'Move to last character in line' })
vim.keymap.set('n', '<M-h>', '^', { desc = 'Move to first character in line' })
-- move around windows
vim.keymap.set('n', '<Down>', '<C-w>j', { desc = 'move to bottom window' })
vim.keymap.set('n', '<Up>', '<C-w>k', { desc = 'move to top window' })
vim.keymap.set('n', '<Left>', '<C-w>h', { desc = 'move to left window' })
vim.keymap.set('n', '<Right>', '<C-w>l', { desc = 'move to right window' })
--
vim.keymap.set('n', '<leader>.', '<C-^>', { desc = 'Switch to last buffer' })
vim.keymap.set('n', '<leader><M-d>', function()
    vim.diagnostic.setqflist()
end, { desc = 'Send diagnostics to qflist' })
--
vim.keymap.set("n", "<leader>q", function()
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
        print('Cant delete last buffer')
        return
    end

    vim.api.nvim_set_current_buf(targetbuf)
    -- only delete buf if its not used by any other window
    if #wins < 2 then
        vim.api.nvim_buf_delete(current, { force = false })
    else
        print('Cant delete last buffer')
    end
end, { desc = "Delete buffer without closing window" })
