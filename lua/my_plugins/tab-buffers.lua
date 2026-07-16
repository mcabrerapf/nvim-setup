local M = {}

local tab_buffers = {}

local function ensure_tab(tab)
    if not tab_buffers[tab] then
        tab_buffers[tab] = {}
    end
    return tab_buffers[tab]
end

local function record_buffer()
    local tab = vim.api.nvim_get_current_tabpage()
    local buf = vim.api.nvim_get_current_buf()

    if not vim.api.nvim_buf_is_valid(buf) then
        return
    end
    ensure_tab(tab)[buf] = true
end

local function wipe_tab_buffers(tab)
    local owned = tab_buffers[tab]
    if not owned then
        return
    end

    for buf in pairs(owned) do
        if vim.api.nvim_buf_is_valid(buf) then
            local still_visible = false

            for other_tab, bufs in pairs(tab_buffers) do
                if other_tab ~= tab and bufs[buf] then
                    still_visible = true
                    break
                end
            end

            if not still_visible then
                pcall(vim.api.nvim_buf_delete, buf, { force = false })
            end
        end
    end

    tab_buffers[tab] = nil
end

function M.setup()
    local group = vim.api.nvim_create_augroup("TabBuffers", {})

    vim.api.nvim_create_autocmd({
        "BufEnter",
        "BufWinEnter",
        "WinEnter"
    }, {
        group = group,
        callback = record_buffer,
    })

    vim.api.nvim_create_autocmd("TabClosed", {
        group = group,
        callback = function(args)
            wipe_tab_buffers(tonumber(args.file))
        end,
    })
end

return M
