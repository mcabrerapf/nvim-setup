vim.pack.add({"https://github.com/jake-stewart/multicursor.nvim"})

local mc = require('multicursor-nvim')
mc.setup()

vim.keymap.set({"n", "x"}, "<c-q>", mc.toggleCursor)

mc.addKeymapLayer(function (layerSet)
    layerSet("n", "<esc>", function ()
        if not mc.cursorsEnabled() then
            mc.enableCursors()
        else
            mc.clearCursors()
        end
    end)
end)
