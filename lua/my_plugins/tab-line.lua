local truncate = require('utils.truncate')
local M = {}

local function get_modified_status(tab_index)
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab_index)) do
        local buf = vim.api.nvim_win_get_buf(win)

        if vim.bo[buf].modified then
            return '●'
        end
    end

    return ' '
end

local function get_real_win_count(tabnr)
    local count = 0

    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabnr)) do
        local buf = vim.api.nvim_win_get_buf(win)
        local bt = vim.bo[buf].buftype

        if bt == "" then
            count = count + 1
        end
    end

    if count > 9 then
        return "+"
    elseif count == 1 then
        return " "
    end


    return count
end

local function get_tab_label(tab_index)
    local tabCwd = vim.fn.getcwd(1, tab_index) or 'Tab'
    return tabCwd
end

M.render_tab_line = function()
    local tabs_content = ""
    local tabs = vim.api.nvim_list_tabpages()
    local total_width = vim.o.columns
    local per_tab = math.floor(total_width / #tabs)
    for i, tab in ipairs(tabs) do
        local is_current = (tab == vim.api.nvim_get_current_tabpage())

        if is_current then
            tabs_content = tabs_content .. "%#TabLineSel#"
        else
            tabs_content = tabs_content .. "%#TabLine#"
        end
        tabs_content =  " " .. tabs_content .. i .. "] "
        tabs_content = tabs_content .. truncate(get_tab_label(tab), per_tab - 2)
        local windows = get_real_win_count(tab)
        tabs_content = tabs_content .. ' ' .. windows
        tabs_content = tabs_content .. get_modified_status(tab) .. ' '
    end

    tabs_content = tabs_content .. "%#TabLineFill#"
    return tabs_content
end

M.setup = function(opts)
    opts = opts or {}
    vim.o.tabline = "%!v:lua.require('my_plugins.tab-line').render_tab_line()"
end

return M
