local M = {}

function M.save(data_file, data)
    local file = io.open(data_file, "w")
    if file then
        file:write(vim.fn.json_encode(data))
        file:close()
    end
end

function M.load(data_file)
    local data = {}
    local file = io.open(data_file, "r")
    if file then
        local content = file:read("*a")
        data = vim.fn.json_decode(content) or {}
        file:close()
    end
    return data
end

return M
