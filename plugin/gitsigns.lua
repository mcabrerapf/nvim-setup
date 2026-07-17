local gh = require("utils.gh")
local ns = vim.api.nvim_create_namespace("modified_files")
local create_floating_window = require("utils.create-floating-window")
vim.pack.add({ gh("lewis6991/gitsigns.nvim") })
local gitsigns = require("gitsigns")

local function next_hunk()
    gitsigns.nav_hunk("next")
end

local function prev_hunk()
    gitsigns.nav_hunk("prev")
end

local function add_diff_stats(buf, files)
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

    for i, file in ipairs(files) do
        vim.api.nvim_buf_set_extmark(buf, ns, i - 1, 0, {
            virt_text = {
                { string.format("%5d ", file.added), "DiffAdd" },
                { string.format("%5d ", file.removed), "DiffDelete" },
            },
            virt_text_win_col = 0,
        })
    end
end

local function get_modified_files()
    vim.fn.system("git rev-parse --is-inside-work-tree")
    if vim.v.shell_error ~= 0 then
        vim.notify("No git repo", vim.log.levels.WARN)
        return {}
    end

    local files = vim.fn.systemlist("git diff --numstat")

    if #files == 0 then
        vim.notify("No modified files", vim.log.levels.INFO)
        return {}
    end
    local parsedFiles = {}
    for _, line in ipairs(files) do
        local added, removed, file = line:match("^(%S+)%s+(%S+)%s+(.+)$")

        added = tonumber(added) or 0
        removed = tonumber(removed) or 0

        table.insert(parsedFiles, {
            file = file,
            added = added,
            removed = removed,
        })
    end
    return parsedFiles
end

-- Keymaps
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
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.tbl_map(function(f)
        return string.rep(" ", 13) .. f.file
    end, modifiedFiles))
    add_diff_stats(buf, modifiedFiles)
    vim.bo[buf].modifiable = false
    local winHeight
    if #modifiedFiles < 25 then
        winHeight = #modifiedFiles
    end
    local win = create_floating_window {
        buf = buf,
        height = winHeight,
        title = "Modified files (" .. #modifiedFiles .. ")",
    }

    vim.keymap.set("n", "<M-l>", function ()
        local line = vim.api.nvim_win_get_cursor(0)[1]
        local file = modifiedFiles[line]

        if file and file.file then
            vim.api.nvim_win_close(win, true)
            vim.api.nvim_buf_delete(buf, { force = true })
            vim.cmd.edit(vim.fn.fnameescape(file.file))
        end
    end, { buf = buf })

    vim.keymap.set("n", "<M-q>", function ()
        vim.api.nvim_win_close(win, true)
        vim.api.nvim_buf_delete(buf, { force = true })
    end, { buf = buf })

    vim.keymap.set("n", "q", function ()
        vim.api.nvim_win_close(win, true)
        vim.api.nvim_buf_delete(buf, { force = true })
    end, { buf = buf })
end, { desc = "Show all modified files" })
