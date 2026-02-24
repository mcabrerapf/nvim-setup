return {
  'nvim-mini/mini.bufremove',
  config = function()
    require('mini.bufremove').setup()

    local removeCurrentBuf = function()
      local currentBufId = vim.api.nvim_get_current_buf()
      MiniBufremove.delete(currentBufId)
    end

    local removeAllOtherBuffers = function()
      local currentBufId = vim.api.nvim_get_current_buf()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) then
          if buf ~= currentBufId then
            MiniBufremove.delete(buf)
          end
        end
      end
    end

    vim.api.nvim_create_user_command('BufRemoveCurrent', removeCurrentBuf, { desc = "Delete current buffer" })
    vim.api.nvim_create_user_command('BufRemoveAllOther', removeAllOtherBuffers, { desc = "Delete ALL other buffers" })
    vim.keymap.set("n", "<leader><leader>q", ":BufRemoveCurrent<CR>", { desc = "Delete current buffer", silent = true })
    vim.keymap.set("n", "<leader><leader>Q", ":BufRemoveAllOther<CR>",
      { desc = "Delete ALL other buffers", silent = true })
  end
}
