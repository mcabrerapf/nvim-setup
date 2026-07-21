local gh = require("utils.gh")
local get_filename = require('utils.get-filename')
local get_filetype_icon = require('utils.get-filetype-icon')
vim.pack.add({ gh("lewis6991/gitsigns.nvim") })

local M = {
    show_cmd = false
}

local function get_branch_name()
    local head = vim.b.gitsigns_head

    if not head then
        return ""
    end
    return " " .. head .. " "
end

local function get_git_diff()
    local dict = vim.b.gitsigns_status_dict

    local added = dict and dict.added or 0
    local changed = dict and dict.changed or 0
    local removed = dict and dict.removed or 0
    if added == 0 and changed == 0 and removed == 0 then
        return ""
    end
    -- return "%#StatuslineGitAdd# " .. string.format("+%d", added) .. " %#StatuslineGitAdd#"
    return string.format("+%d ~%d -%d", added, changed, removed)
end

local function get_mode()
    -- Note: termcodes \19 and \22 are ^S and ^V
    local mode_options = {
        ["n"] = { name = "N", hl = "Normal" },
        ["no"] = { name = "OP", hl = "Pending" },
        ["nov"] = { name = "OP", hl = "Pending" },
        ["noV"] = { name = "OP", hl = "Pending" },
        ["no\22"] = { name = "OP", hl = "Pending" },
        ["niI"] = { name = "N", hl = "Normal" },
        ["niR"] = { name = "N", hl = "Normal" },
        ["niV"] = { name = "N", hl = "Normal" },
        ["nt"] = { name = "N", hl = "Normal" },
        ["ntT"] = { name = "N", hl = "Normal" },
        ["v"] = { name = "V", hl = "Visual" },
        ["vs"] = { name = "V", hl = "Visual" },
        ["V"] = { name = "V-L", hl = "Visual" },
        ["Vs"] = { name = "V-L", hl = "Visual" },
        ["\22"] = { name = "V-B", hl = "Visual" },
        ["\22s"] = { name = "V-B", hl = "Visual" },
        ["s"] = { name = "S", hl = "Insert" },
        ["S"] = { name = "S-L", hl = "Normal" },
        ["\19"] = { name = "S-B", hl = "Normal" },
        ["i"] = { name = "I", hl = "Insert" },
        ["ic"] = { name = "I", hl = "Insert" },
        ["ix"] = { name = "I", hl = "Insert" },
        ["R"] = { name = "R", hl = "Replace" },
        ["Rc"] = { name = "R", hl = "Replace" },
        ["Rx"] = { name = "R", hl = "Replace" },
        ["Rv"] = { name = "V-R", hl = "Replace" },
        ["Rvc"] = { name = "V-R", hl = "Replace" },
        ["Rvx"] = { name = "V-R", hl = "Replace" },
        ["c"] = { name = "C", hl = "Command" },
        ["cv"] = { name = "EX", hl = "Command" },
        ["ce"] = { name = "EX", hl = "Command" },
        ["r"] = { name = "R", hl = "Normal" },
        ["rm"] = { name = "MORE", hl = "Normal" },
        ["r?"] = { name = "CONFIRM", hl = "Normal" },
        ["!"] = { name = "SH", hl = "Normal" },
        ["t"] = { name = "TERM", hl = "Command" },
    }
    local mode = mode_options[vim.fn.mode()] or {}
    local modeText = mode.name .. ' ' .. get_branch_name()
    if M.show_cmd == true then
        modeText = vim.fn.getcwd()
    end

    return table.concat({
        -- "%#StatuslineMode" .. mode.hl .. "Inverted" .. "#",
        "%#StatuslineMode" .. mode.hl .. "#" .. " " .. modeText,
        "%#StatuslineMode" .. mode.hl .. "Inverted#"
        -- "%#StatuslineMode" .. mode.hl .. "Inverted" .. "#",
    })
end

local function get_current_lsp()
    local bufId = vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
    local lspClients = vim.lsp.get_clients({ bufnr = bufId })
    if #lspClients == 0 then
        return ''
    end
    -- local firstCllient = lspClients[1].name
    local clientIcon = get_filetype_icon()
    return clientIcon .. ' | '
end

local function get_left_side(is_active)
    if not is_active then return get_filename() end
    return table.concat({
        get_mode(),
        " " .. get_filename(),
    })
end

local function get_right_side(is_active)
    if not is_active then
        return '%= %l:%c %p%%'
    end
    local gitDiff = get_git_diff()
    if gitDiff ~= '' then
        return get_current_lsp() .. gitDiff .. ' | ' .. '%l:%c %p%%'
    end
    return get_current_lsp() .. '%l:%c %p%%'
end

M.render_status_line = function()
    local active_win = vim.fn.win_getid()
    local status_win = vim.g.statusline_winid
    local isActive = status_win == active_win

    return table.concat({
        get_left_side(isActive),
        "%=",
        get_right_side(isActive)
    })
end

M.setup = function(opts)
    opts = opts or {}
    M.show_cmd = opts.show_cmd or false
    vim.o.statusline = "%!v:lua.require('my_plugins.status-line').render_status_line()"
end

return M
