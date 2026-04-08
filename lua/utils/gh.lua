local function gh(path)
    if path == "" or path == nil then
        return ''
    end
    return "https://github.com/" .. path
end

return gh
