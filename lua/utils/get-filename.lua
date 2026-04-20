local function get_filename()
    local bufId = vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
    local bufName = vim.api.nvim_buf_get_name(bufId)
    local baseName = vim.fs.basename(bufName)
    if baseName == '' then return '[No Name]' end
    local bufInfo = vim.fn.getbufinfo(bufId)
    if #bufInfo < 1 then
        return bufName
    end
    local isModified = bufInfo[1].changed
    if isModified ~= 0 then
        baseName  = baseName .. '  ●'
    end
    return baseName
end

return get_filename
