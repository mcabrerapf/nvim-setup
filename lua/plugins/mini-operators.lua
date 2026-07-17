local gh = require("utils.gh")
vim.pack.add({ gh("nvim-mini/mini.operators") })
require('mini.operators').setup({ replace = { prefix = 'cr' } })
