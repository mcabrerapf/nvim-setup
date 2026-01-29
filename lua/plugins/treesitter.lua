return {
  -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  branch = 'master',
  lazy = false,
  build = ':TSUpdate',
  opts = {
    highlight = {
      enable = true,
      indent = {
        enable = true,
      },
    },
  },
  -- main = 'nvim-treesitter.config', -- Sets main module to use for opts
  -- config = function()
  --   require('nvim-treesitter').setup {
  --     -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
  --     install_dir = vim.fn.stdpath 'data' .. '/site',
  --   }
  --   require('nvim-treesitter').install {
  --     -- 'javascript',
  --     -- 'html',
  --     'gdscript',
  --     -- 'gdshader',
  --     -- 'godot_resource',
  --     -- 'bash',
  --     -- 'lua',
  --     -- 'luadoc',
  --     -- 'markdown',
  --     -- 'markdown_inline',
  --     -- 'vim',
  --     -- 'vimdoc',
  --   }
  -- end,
}
