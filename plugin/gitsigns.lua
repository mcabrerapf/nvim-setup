local gh = require("utils.gh")
vim.pack.add({ gh("lewis6991/gitsigns.nvim") })
local gitsigns = require("gitsigns")

local function next_hunk()
    gitsigns.nav_hunk("next")
end

local function prev_hunk()
    gitsigns.nav_hunk("prev")
end

vim.keymap.set("n", "<leader>gc", gitsigns.show_commit, { desc = "Show commit" })
vim.keymap.set("n", "<leader>gd", gitsigns.diffthis, { desc = "Show diff" })
vim.keymap.set("n", "<leader>gB", gitsigns.blame, { desc = "File blame" })
vim.keymap.set("n", "<leader>gb", gitsigns.blame_line, { desc = "Line blame" })
vim.keymap.set("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Stage buffer" })
vim.keymap.set("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Stage/unstage hunk" })
vim.keymap.set("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Reset buffer" })
vim.keymap.set("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Reset hunk" })
vim.keymap.set("n", "<leader>gh", gitsigns.select_hunk, { desc = "Select hunk" })
vim.keymap.set("n", "<leader>g]", next_hunk, { desc = "Next hunk" })
vim.keymap.set("n", "<leader>g[", prev_hunk, { desc = "Prev hunk" })
