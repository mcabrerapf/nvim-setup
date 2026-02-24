return {
  'nvim-mini/mini.operators',
  config = function()
    require('mini.operators').setup({ replace = { prefix = 'cr' } })
  end
}
