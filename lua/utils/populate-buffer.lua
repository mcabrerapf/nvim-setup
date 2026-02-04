local function populate_buffer(buf, sessions, opts)
  opts = opts or {}
  local modifiable = opts.modifiable or false
  -- local filetype = opts.filetype or 'new_buffer'
  local buftype = opts.buftype or 'nofile'
  local bufhidden = opts.buffhidden or 'hide'

  vim.api.nvim_set_option_value('modifiable', true, { buf = buf })
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, sessions)
  vim.api.nvim_set_option_value('modifiable', modifiable, { buf = buf })

  vim.bo[buf].buftype = buftype
  vim.bo[buf].bufhidden = bufhidden
  -- vim.bo[buf].filetype = filetype
end

return populate_buffer
