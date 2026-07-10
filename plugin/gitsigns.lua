local gh = require("utils.gh")
local create_floating_window = require("utils.create-floating-window")
vim.pack.add({ gh("lewis6991/gitsigns.nvim") })
local gitsigns = require("gitsigns")

local function next_hunk()
    gitsigns.nav_hunk("next")
end

local function prev_hunk()
    gitsigns.nav_hunk("prev")
end

local function get_modified_files()
    local files = vim.fn.systemlist("git diff --name-only")
    local items = {}

     if vim.v.shell_error ~= 0 then
        vim.notify("No git repo", vim.log.levels.WARN)
        return {}
    end

    if #files == 0 then
        vim.notify("No modified files", vim.log.levels.INFO)
        return {}

    end
    for _, file in ipairs(files) do
        table.insert(items, file)
    end
    return items
end

vim.keymap.set("n", "<leader>gb", gitsigns.blame_line, { desc = "Line blame" })
vim.keymap.set("n", "<leader>gB", gitsigns.blame, { desc = "File blame" })
vim.keymap.set("n", "<leader>gc", gitsigns.show_commit, { desc = "Show commit" })
vim.keymap.set("n", "<leader>gd", gitsigns.diffthis, { desc = "Show diff" })

vim.keymap.set("n", "<leader>gh", gitsigns.select_hunk, { desc = "Select hunk" })
vim.keymap.set("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Preview hunk" })
vim.keymap.set("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Reset hunk" })
vim.keymap.set("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Reset buffer" })
vim.keymap.set("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Stage buffer" })
vim.keymap.set("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Stage/unstage hunk" })
vim.keymap.set("n", "<leader>g]", next_hunk, { desc = "Next hunk" })
vim.keymap.set("n", "<leader>g[", prev_hunk, { desc = "Prev hunk" })

vim.keymap.set("n", "<leader>gf", function ()
    local modifiedFiles = get_modified_files()
    if #modifiedFiles < 1 then return end
    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, modifiedFiles)
    vim.bo[buf].modifiable = false
    local win = create_floating_window {
        buf = buf,
        width = 55,
        height = 20,
        title = 'Modified files',
        style = ''
    }
    vim.keymap.set('n', '<M-q>', function ()
        vim.api.nvim_win_close(win, true)
        vim.api.nvim_buf_delete(buf, { force = true })
    end, { buf = buf })
end, { desc = "Show all changed files" })
