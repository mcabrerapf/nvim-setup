local function populate_buffer(buf, sessions, opts)
  opts = opts or {}
  local modifiable = opts.modifiable or false
  local filetype = opts.filetype or 'new_buffer'

  vim.api.nvim_buf_set_option(buf, 'modifiable', true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, sessions)
  vim.api.nvim_buf_set_option(buf, 'modifiable', modifiable)

  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].bufhidden = 'hide'
  vim.bo[buf].filetype = filetype
end

return populate_buffer
