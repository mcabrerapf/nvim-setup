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

    vim.api.nvim_create_user_command('BufRemoveCurrent', removeCurrentBuf, { desc = "Close current buffer" })
    vim.api.nvim_create_user_command('BufRemoveAllOther', removeAllOtherBuffers, { desc = "Close ALL other buffers" })
    vim.keymap.set("n", "<leader>q", ":BufRemoveCurrent<CR>", { desc = "Close current buffer", silent = true })
    vim.keymap.set("n", "<leader>Q", ":BufRemoveAllOther<CR>",
      { desc = "Close ALL other buffers", silent = true })
  end
}
