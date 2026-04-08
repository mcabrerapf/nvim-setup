local gh = require("utils.gh")
vim.pack.add({ gh("nvim-treesitter/nvim-treesitter") })

-- local install_dir = vim.fn.stdpath('data') .. '/site'
-- vim.opt.runtimepath:append(install_dir)

local treesitter = require 'nvim-treesitter'
local ensureInstalled = {
    'gdscript',
    'gdshader',
    'godot_resource',
    'javascript',
    'html',
    'typescript',
    'json'
}
vim.api.nvim_create_autocmd(
    'PackChanged',
    {
        callback = function(ev)
            local name, kind = ev.data.spec.name, ev.data.kind
            if name == 'nvim-treesitter' and kind == 'update' then
                if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
                vim.cmd('TSUpdate')
            end
        end
    }
)

treesitter.setup {
    install_dir = vim.fn.stdpath 'data' .. '/site',
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
    },
    textobjects = {
        select = { enable = true },
        move = { enable = true },
    },
    indent = {
        enable = true, -- optional: better indentation
    },
}

treesitter.install(ensureInstalled)

vim.api.nvim_create_autocmd('FileType', {
    pattern = ensureInstalled,
    callback = function()
        vim.treesitter.start()
        vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.wo[0][0].foldmethod = 'expr'
        -- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})
