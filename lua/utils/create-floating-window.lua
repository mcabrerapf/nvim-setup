local create_floating_window = function(opts)
  opts = opts or {}
  local buf = opts.buf
  local width = opts.width or math.floor(vim.o.columns * 0.6)
  local height = opts.height or math.floor(vim.o.lines * 0.6)
  local border = opts.border or 'rounded'
  local title = opts.title or ''
  local title_pos = opts.title_pos or 'center'
  local col = opts.col or math.floor((vim.o.columns - width) / 2)
  local row = opts.row or math.floor((vim.o.lines - height) / 2)
  local anchor = opts.anchor or 'NW'
  local fixed = opts.fixed or false
  local should_enter = opts.should_enter ~= false

  local win_config = {
    relative = 'editor',
    style = 'minimal', -- No borders or extra UI elements
    border = border,
    fixed = fixed,
    width = width,
    height = height,
    col = col,
    row = row,
    title = title,
    title_pos = title_pos,
    anchor = anchor,
  }
  local win = vim.api.nvim_open_win(buf, should_enter, win_config)
  return { buf = buf, win = win }
end

return create_floating_window
