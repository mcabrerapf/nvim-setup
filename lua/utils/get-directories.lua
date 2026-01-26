local get_directories = function(root)
  local dirs = {}
  for _, name in ipairs(vim.fn.readdir(root)) do
    local full = root .. '/' .. name
    if vim.fn.isdirectory(full) == 1 then
      table.insert(dirs, name)
    end
  end
  return dirs
end

return get_directories
