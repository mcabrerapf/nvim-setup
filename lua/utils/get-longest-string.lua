local function get_longest_string(table)
  local max_len = 0
  local longest_name = ''
  for _, name in ipairs(table) do
    if #name > max_len then
      max_len = #name
      longest_name = name
    end
  end
  return max_len, longest_name
end

return get_longest_string
