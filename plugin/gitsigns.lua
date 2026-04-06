local gh = require("utils.gh")
vim.pack.add({ gh("lewis6991/gitsigns.nvim") })
local gitsigns = require("gitsigns")
-- Keymaps
vim.keymap.set("n", "<leader>gc", function ()
    gitsigns.show_commit()
end, {
    desc = "Show commit"
})

vim.keymap.set("n", "<leader>gd", function ()
    gitsigns.diffthis()
end, {
    desc = "Show diff"
})

vim.keymap.set("n", "<leader>gB", function ()
    gitsigns.blame()
end, {
    desc = "File blame"
})

vim.keymap.set("n", "<leader>gb", function ()
    gitsigns.blame_line()
end, {
    desc = "Line blame"
})

vim.keymap.set("n", "<leader>gS", function ()
    gitsigns.stage_buffer()
end, {
    desc = "Stage buffer"
})

vim.keymap.set("n", "<leader>gs", function ()
    gitsigns.stage_hunk()
end, {
    desc = "Stage/unstage hunk"
})

vim.keymap.set("n", "<leader>gR", function ()
    gitsigns.reset_buffer()
end, {
    desc = "Reset buffer"
})

vim.keymap.set("n", "<leader>gr", function ()
    gitsigns.reset_hunk()
end, {
    desc = "Reset hunk"
})

vim.keymap.set("n", "<leader>gh", function ()
    gitsigns.select_hunk()
end, {
    desc = "Select hunk"
})

vim.keymap.set("n", "<leader>g]", function ()
    gitsigns.nav_hunk("next")
end, {
    desc = "Next hunk"
})

vim.keymap.set("n", "<leader>g[", function ()
    gitsigns.nav_hunk("prev")
end, {
    desc = "Prev hunk"
})
