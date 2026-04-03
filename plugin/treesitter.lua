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

vim.pack.add({"https://github.com/nvim-treesitter/nvim-treesitter"})

local treesitter = require 'nvim-treesitter'
treesitter.setup {
    -- directory to install parsers and queries to (prepended to `runtimepath` to have priority)
    install_dir = vim.fn.stdpath 'data' .. '/site',
    highlight = {
        enable = true, -- enable treesitter syntax highlighting
        additional_vim_regex_highlighting = false,
    },
    textobjects = {
        select = { enable = true },
        move = { enable = true },
    },
    indent = {
        enable = true, -- optional: better indentation
    },
}

treesitter.install {
    'gdscript',
    'gdshader',
    'godot_resource',
    'rust',
    'javascript',
    'html',
    'zig',
    'typescript',
    'json'
}

vim.api.nvim_create_autocmd('FileType', {
    pattern = {'lua', 'gdscript', 'gdshader', 'godot_resource', 'javascript', 'html', 'typescript', 'json' },
    callback = function()
        vim.treesitter.start()
        vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.wo[0][0].foldmethod = 'expr'
    -- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})
