return {
  'nvim-mini/mini.ai',
  config = function()
    require('mini.ai').setup { n_lines = 500 }
  end
}
