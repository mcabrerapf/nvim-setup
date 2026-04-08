local function keymap(lhs, rhs, desc, buf, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, lhs, rhs, { desc = desc, buf = buf })
end

return keymap
