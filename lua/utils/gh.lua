local gh = function (path)
    if path == "" or path == nil then
        return nil
    end
   return "https://github.com/" .. path
end

return gh
