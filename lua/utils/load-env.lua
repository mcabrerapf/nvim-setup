local function load_env()
  local allowed_keys = {
    GODOT_PROJECTS_PATH = true,
    GODOT_EXE_PATH = true,
    GODOT_SERVER_PORT = true,
  }
  vim.fn.setenv('NOTES_DIR_PATH', vim.fn.stdpath 'config' .. '/notes')
  vim.fn.setenv('SESSIONS_DIR_PATH', vim.fn.stdpath 'config' .. '/sessions')
  local env_path = vim.fn.stdpath 'config' .. '/.env'
  local file = io.open(env_path, 'r')

  if not file then
    vim.notify('No .env file found at ' .. env_path, vim.log.levels.DEBUG)
    return
  end

  for line in file:lines() do
    local key, value = line:match '^%s*([^=]+)%s*=%s*(.*)%s*$'

    if key and value and allowed_keys[key] then
      vim.env[key] = value
    end
  end
  file:close()
end
return load_env
