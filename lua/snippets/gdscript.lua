-- local ls = require 'luasnip'
-- local s = ls.snippet
-- local sn = ls.snippet_node
-- local t = ls.text_node
-- local i = ls.insert_node
-- -- local f = ls.function_node
-- local d = ls.dynamic_node
-- -- local fmt = require("luasnip.extras.fmt").fmt
-- local fmta = require('luasnip.extras.fmt').fmta
-- local rep = require('luasnip.extras').rep

return {
  -- NOTE: Enter and exit tree functons
  s(
    { trig = 'fee' },
    fmta(
      [[
	func _enter_tree() ->> void:
		<>.connect(<>)


	func _exit_tree() ->> void:
		<>.disconnect(<>)


	]],
      {
        i(1, 'signal_name'),
        i(2, 'func_name'),
        rep(1),
        rep(2),
      }
    )
  ),
}, {
  -- NOTE: AUTOLOADS
  -- Basic function
  s(
    { trig = 'func', snippetType = 'autosnippet' },
    fmta(
      [[
	func <>(<>) ->> <>:
		<>


	]],
      {
        i(1, 'name'),
        i(2, 'param'),
        i(3, 'void'),
        i(4, 'return'),
      }
    )
  ),
  --
}

-- ls.add_snippets('gdscript', {
--
--   -- s(
--   --   { trig = 'func', snippetType = 'autosnippet' },
--   --   fmta(
--   --     [[
--   --   func <>(<>) - >> <>:
--   --   ]],
--   --     { i(1), rep(1), i(3) }
--   --   ),
--   --   {
--   --     t { '', '\t' },
--   --     i(4),
--   --   }
--   -- ),
--   -- s(
--   --   { trig = 'tree' },
--   --   fmta(
--   --     [[
--   --     func _enter_tree():
--   --     <>
--   --
--   --     func _exit_tree():
--   --     <>
--   --     ]],
--   --     {
--   --       { t '\t', i(1, '-- setup') },
--   --       { t '\t', rep(1) },
--   --     }
--   --   )
--   -- ),
-- })
