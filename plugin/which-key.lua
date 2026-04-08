local gh = require("utils.gh")
vim.pack.add({ gh("folke/which-key.nvim") })
local wk = require("which-key")

wk.add({
    { "<leader>f", group = "File explorer" },
    { "<leader>s", group = "Search" },
    { "<leader>n", group = "Notes" },
    { "<leader>e", group = "Sessions" },
    { "<leader>g", group = "Git" },
})
