local function truncate(str, max_len)
    if vim.fn.strdisplaywidth(str) <= max_len then
        return str
    end

    if max_len <= 1 then
        return "…"
    end

    return vim.fn.strcharpart(str, 0, max_len - 1) .. "…"
end

return truncate
