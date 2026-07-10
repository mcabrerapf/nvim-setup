local gh = require("utils.gh")

vim.pack.add({ gh("stevearc/quicker.nvim") })
require("quicker").setup({
  keys = {
    {
      ">",
      function()
        require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
      end,
      desc = "Expand quickfix context",
    },
    {
      "<",
      function()
        require("quicker").collapse()
      end,
      desc = "Collapse quickfix context",
    },
    {
        "<M-r>",
        function ()
            require("quicker").refresh()
        end,
        desc = "Refresh list"
    }
  },
})
vim.keymap.set("n", "<leader>q", function()
  require("quicker").toggle({ focus = true})
end, {
  desc = "Toggle quickfix",
})
vim.keymap.set("n", "<leader>l", function()
  require("quicker").toggle({ loclist = true, focus = true })
end, {
  desc = "Toggle loclist",
})
