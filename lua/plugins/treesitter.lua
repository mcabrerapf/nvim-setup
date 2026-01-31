return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    local treesitter = require 'nvim-treesitter'
    treesitter.setup {
      -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
      install_dir = vim.fn.stdpath 'data' .. '/site',
      treesitter.install { 'gdscript', 'gdshader', 'godot_resource', 'rust', 'javascript', 'zig' },
      highlight = {
        enable = true, -- enable Treesitter syntax highlighting
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true, -- optional: better indentation
      },
    }

    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'gdscript', 'gdshader', 'godot_resource' },
      callback = function()
        vim.treesitter.start()
        vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.wo[0][0].foldmethod = 'expr'
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
