local M = {}

local function truncate(str, max_len)
    if vim.fn.strdisplaywidth(str) <= max_len then
        return str
    end

    if max_len <= 1 then
        return "…"
    end

    return vim.fn.strcharpart(str, 0, max_len - 1) .. "…"
end

local function get_modified_status(tab)
    if not vim.api.nvim_tabpage_is_valid(tab) then
        return '  '
    end

    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
        if vim.api.nvim_win_is_valid(win) then
            local buf = vim.api.nvim_win_get_buf(win)

            if vim.bo[buf].modified then
                return ' ●'
            end
        end
    end

    return '  '
end

local function get_tab_label(tab)
    if not vim.api.nvim_tabpage_is_valid(tab) then
        return 'Tab'
    end

    local ok, tab_number = pcall(vim.api.nvim_tabpage_get_number, tab)

    if not ok then
        return 'Tab'
    end

    local ook, cwd = pcall(vim.fn.getcwd, -1, tab_number)

    if ook and cwd then
        return cwd
    end

    return 'Tab'
end

M.render_tab_line = function()
    local tabs = vim.api.nvim_list_tabpages()

    if #tabs == 0 then
        return ''
    end

    local tabs_content = ""
    local total_width = vim.o.columns
    local per_tab = math.floor(total_width / #tabs)
    local current_tab = vim.api.nvim_get_current_tabpage()

    for i, tab in ipairs(tabs) do
        if vim.api.nvim_tabpage_is_valid(tab) then
            local is_current = (tab == current_tab)

            if is_current then
                tabs_content = tabs_content .. "%#TabLineSel#"
            else
                tabs_content = tabs_content .. "%#TabLine#"
            end

            tabs_content = tabs_content .. ' ' .. i .. ") "
            tabs_content = tabs_content .. truncate(get_tab_label(tab), per_tab - 2)
            tabs_content = tabs_content .. get_modified_status(tab)
            tabs_content = tabs_content .. ' '
        end
    end

    tabs_content = tabs_content .. "%#TabLineFill#"

    return tabs_content
end

M.setup = function(opts)
    opts = opts or {}

    vim.o.tabline = "%!v:lua.require('my_plugins.tab-line').render_tab_line()"
end

return M
