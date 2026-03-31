
vim.pack.add({"https://github.com/navarasu/onedark.nvim"})

require('onedark').setup {
    style = 'warmer', -- **Options:**  dark, darker, cool, deep, warm, warmer, light
    code_style = {
        comments = 'none',
        keywords = 'bold,italic',
        functions = 'bold',
        strings = 'none',
        variables = 'bold',
    },
    transparent = true,
    term_colors = true,
    toggle_style_key = "<leader>ts",
    toggle_style_list = { 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' }, -- List of styles to toggle between
}
require('onedark').load()
