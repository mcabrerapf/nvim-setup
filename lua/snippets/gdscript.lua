local ls = require 'luasnip'
local s = ls.snippet
-- local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
-- local f = ls.function_node
-- local d = ls.dynamic_node
-- local isn = ls.indent_snippet_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require('luasnip.extras.fmt').fmta
local rep = require('luasnip.extras').rep

return {
}, {
  s(
    {
      trig = 'fnd',
      snippetType = 'autosnippet'
    },
    fmta(
      [[
	    func <fName>(<fArgs>) ->> <fReturn>:
		      <fBody>
	    ]],
      {
        fName = i(1, '_name'),
        fArgs = i(2),
        fReturn = i(3, 'void'),
        fBody = i(4, 'return'),
      }
    )
  ),
  --
}
