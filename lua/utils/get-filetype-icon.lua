vim.pack.add({ "https://github.com/nvim-tree/nvim-web-devicons" })
local devicons = require 'nvim-web-devicons'

local function get_filetype_icon()
    local bufId = vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
    local bufName = vim.api.nvim_buf_get_name(bufId)
    local baseName = vim.fs.basename(bufName)
    local ext = vim.fn.fnamemodify(baseName, ':e')
    local icon = devicons.get_icon(baseName, ext, { default = true })
    return icon or ''
end

return get_filetype_icon
