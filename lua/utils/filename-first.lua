local devicons = require 'nvim-web-devicons'

local filename_first = function(buf_id, item_arr)
  local lines = {}

  for i, item in ipairs(item_arr) do
    local directory = vim.fs.dirname(item)
    local basename = vim.fs.basename(item)
    local ext = vim.fn.fnamemodify(basename, ':e')
    local icon, icon_hl = devicons.get_icon(basename, ext, { default = true })
    icon = icon or ''
    icon_hl = icon_hl or 'Normal'
    local line = string.format('%s %s /%s', icon, basename, directory)
    lines[i] = line
  end

  vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)

  for i, item in ipairs(item_arr) do
    local basename = vim.fs.basename(item)
    local ext = vim.fn.fnamemodify(basename, ':e')
    local icon, icon_hl = devicons.get_icon(basename, ext, { default = true })
    icon_hl = icon_hl or 'Normal'
    vim.api.nvim_buf_add_highlight(buf_id, -1, icon_hl, i - 1, 0, #icon)
    vim.api.nvim_buf_add_highlight(buf_id, -1, 'CustomHighlightedText', i - 1, #icon + 1, #icon + 1 + #basename)
  end
end

return filename_first
