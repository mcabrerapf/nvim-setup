local gh = require("utils.gh")
vim.pack.add({ gh("folke/which-key.nvim") })
local wk = require("which-key")

wk.add({
    { "<leader>f", group = "File explorer" },
    { "<leader>g", group = "Git" },
    { "<leader>n", group = "Notes" },
    { "<leader>o", group = "Org" },
    { "<leader>s", group = "Search" },
    { "<leader>e", group = "Sessions" },
    { "<leader>t", group = "Theme" },
})
