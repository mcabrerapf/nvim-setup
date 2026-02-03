return {
  -- Main LSP Configuration
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'mason-org/mason.nvim', opts = {} },
    { 'mason-org/mason-lspconfig.nvim', opts = {} },
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    -- { 'j-hui/fidget.nvim', opts = {} },
    'saghen/blink.cmp',
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
        map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method('textDocument/documentHighlight', event.buf) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        if client and client:supports_method('textDocument/inlayHint', event.buf) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    local capabilities = require('blink.cmp').get_lsp_capabilities()

    -- Enable the following language servers
    --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
    --  See `:help lsp-config` for information about keys and how to configure
    local servers = {
      ts_ls = {},
      -- gdscript = {},
      -- gdshader ={},
      -- godot_resource ={},
      html = {},
      lua_ls = {},
      -- markup ={},
      -- javascript ={},
      -- clangd = {},
      -- gopls = {},
      -- pyright = {},
      -- rust_analyzer = {},
      --
      -- Some languages (like typescript) have entire language plugins that can be useful:
      --    https://github.com/pmizio/typescript-tools.nvim
      --
      -- But for many setups, the LSP (`ts_ls`) will work just fine
      -- ts_ls = {},
    }

    -- Ensure the servers and tools above are installed
    --
    -- To check the current status of installed tools and/or manually install
    -- other tools, you can run
    --    :Mason
    --
    -- You can press `g?` for help in this menu.
    local ensure_installed = vim.tbl_keys(servers or {})
    -- vim.list_extend(ensure_installed, {
    --   'lua_ls', -- Lua Language server
    --   'stylua', -- Used to format Lua code
    --   -- You can add other tools here that you want Mason to install
    -- })

    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    for name, server in pairs(servers) do
      server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
      vim.lsp.config(name, server)
      vim.lsp.enable(name)
    end

    -- Special Lua Config, as recommended by neovim help docs
    vim.lsp.config('lua_ls', {
      on_init = function(client)
        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
            return
          end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
          runtime = {
            version = 'LuaJIT',
            path = { 'lua/?.lua', 'lua/?/init.lua' },
          },
          workspace = {
            checkThirdParty = false,
            -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
            --  See https://github.com/neovim/nvim-lspconfig/issues/3189
            library = vim.api.nvim_get_runtime_file('', true),
          },
        })
      end,
      settings = {
        Lua = {},
      },
    })
    vim.lsp.enable 'lua_ls'
    -- Godot bits
    vim.lsp.config('gdscript', { capabilities = capabilities })
    vim.lsp.enable { 'gdscript' }

    vim.lsp.config('gdshader', { capabilities = capabilities })
    vim.lsp.enable { 'gdshader' }

    vim.lsp.config('godot_resource', { capabilities = capabilities })
    vim.lsp.enable { 'godot_resource' }
  end,
}
-- WORKING LSP
-- return {
--   'neovim/nvim-lspconfig',
--   dependencies = {
--     -- Automatically install LSPs and related tools to stdpath for Neovim
--     -- Mason must be loaded before its dependents so we need to set it up here.
--     -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
--     { 'mason-org/mason.nvim', opts = {} },
--     'mason-org/mason-lspconfig.nvim',
--     'WhoIsSethDaniel/mason-tool-installer.nvim',
--
--     -- Useful status updates for LSP.
--     { 'j-hui/fidget.nvim', opts = {} },
--
--     -- Allows extra capabilities provided by blink.cmp
--     'saghen/blink.cmp',
--   },
--   config = function()
--     local capabilities = require('blink.cmp').get_lsp_capabilities()
--     vim.lsp.config('gdscript', { capabilities = capabilities })
--     vim.lsp.config('lua_ls', { capabilities = capabilities })
--     vim.lsp.config('javascript', { capabilities = capabilities })
--     vim.lsp.enable { 'lua_ls', 'gdscript', 'javascript', 'html' }
--     --  This function gets run when an LSP attaches to a particular buffer.
--     --    That is to say, every time a new file is opened that is associated with
--     --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
--     --    function will be executed to configure the current buffer
--     vim.api.nvim_create_autocmd('LspAttach', {
--       group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
--       callback = function(event)
--         -- NOTE: Remember that Lua is a real programming language, and as such it is possible
--         -- to define small helper and utility functions so you don't have to repeat yourself.
--         -- In this case, we create a function that lets us more easily define mappings specific
--         -- for LSP related items. It sets the mode, buffer and description for us each time.
--         local map = function(keys, func, desc, mode)
--           mode = mode or 'n'
--           vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
--         end
--
--         -- Rename the variable under your cursor.
--         --  Most Language Servers support renaming across files, etc.
--         map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
--
--         -- Execute a code action, usually your cursor needs to be on top of an error
--         -- or a suggestion from your LSP for this to activate.
--         map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
--
--         -- Find references for the word under your cursor.
--         -- map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
--         local extra = require 'mini.extra'
--         vim.keymap.set('n', 'grd', function()
--           extra.pickers.lsp { scope = 'declaration' }
--         end, { desc = 'Go to [d]eclaration' })
--         -- map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
--         --
--         vim.keymap.set('n', 'grD', function()
--           extra.pickers.lsp { scope = 'definition' }
--         end, { desc = '[G]oto [D]efinition' })
--         --
--         vim.keymap.set('n', 'grr', function()
--           extra.pickers.lsp { scope = 'references' }
--         end, { desc = '[G]oto [R]eferences' })
--         --
--         vim.keymap.set('n', 'gri', function()
--           extra.pickers.lsp { scope = 'implementation' }
--         end, { desc = '[G]oto [I]mplementation' })
--         --
--         vim.keymap.set('n', 'grt', function()
--           extra.pickers.lsp { scope = 'type_definition' }
--         end, { desc = '[G]oto [T]ype Definition' })
--         --
--         vim.keymap.set('n', 'grs', function()
--           extra.pickers.lsp { scope = 'document_symbol' }
--         end, { desc = '[G]oto Document [S]ymbols' })
--         --
--         vim.keymap.set('n', 'grS', function()
--           extra.pickers.lsp { scope = 'workspace_symbol' }
--         end, { desc = '[G]oto Workspace [S]ymbols' })
--         --
--         vim.keymap.set('n', 'grN', function()
--           extra.lsp.rename()
--         end, { desc = '[R]ename symbol' })
--         -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
--         ---@param client vim.lsp.Client
--         ---@param method vim.lsp.protocol.Method
--         ---@param bufnr? integer some lsp support methods only in specific files
--         ---@return boolean
--         local function client_supports_method(client, method, bufnr)
--           if vim.fn.has 'nvim-0.11' == 1 then
--             return client:supports_method(method, bufnr)
--           else
--             return client.supports_method(method, { bufnr = bufnr })
--           end
--         end
--
--         -- The following two autocommands are used to highlight references of the
--         -- word under your cursor when your cursor rests there for a little while.
--         --    See `:help CursorHold` for information about when this is executed
--         --
--         -- When you move your cursor, the highlights will be cleared (the second autocommand).
--         local client = vim.lsp.get_client_by_id(event.data.client_id)
--         if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
--           local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
--           vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
--             buffer = event.buf,
--             group = highlight_augroup,
--             callback = vim.lsp.buf.document_highlight,
--           })
--
--           vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
--             buffer = event.buf,
--             group = highlight_augroup,
--             callback = vim.lsp.buf.clear_references,
--           })
--
--           vim.api.nvim_create_autocmd('LspDetach', {
--             group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
--             callback = function(event2)
--               vim.lsp.buf.clear_references()
--               vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
--             end,
--           })
--         end
--
--         -- The following code creates a keymap to toggle inlay hints in your
--         -- code, if the language server you are using supports them
--         --
--         -- This may be unwanted, since they displace some of your code
--         if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
--           map('<leader>th', function()
--             vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
--           end, '[T]oggle Inlay [H]ints')
--         end
--       end,
--     })
--
--     -- Diagnostic Config
--     -- See :help vim.diagnostic.Opts
--     vim.diagnostic.config {
--       severity_sort = true,
--       float = { border = 'rounded', source = 'if_many' },
--       underline = { severity = vim.diagnostic.severity.ERROR },
--       signs = vim.g.have_nerd_font and {
--         text = {
--           [vim.diagnostic.severity.ERROR] = '󰅚 ',
--           [vim.diagnostic.severity.WARN] = '󰀪 ',
--           [vim.diagnostic.severity.INFO] = '󰋽 ',
--           [vim.diagnostic.severity.HINT] = '󰌶 ',
--         },
--       } or {},
--       virtual_text = {
--         source = 'if_many',
--         spacing = 2,
--         format = function(diagnostic)
--           local diagnostic_message = {
--             [vim.diagnostic.severity.ERROR] = diagnostic.message,
--             [vim.diagnostic.severity.WARN] = diagnostic.message,
--             [vim.diagnostic.severity.INFO] = diagnostic.message,
--             [vim.diagnostic.severity.HINT] = diagnostic.message,
--           }
--           return diagnostic_message[diagnostic.severity]
--         end,
--       },
--     }
--     -- LSP servers and clients are able to communicate to each other what features they support.
--     --  By default, Neovim doesn't support everything that is in the LSP specification.
--     --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
--     --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
--
--     -- Enable the following language servers
--     --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--     --
--     --  Add any additional override configuration in the following tables. Available keys are:
--     --  - cmd (table): Override the default command used to start the server
--     --  - filetypes (table): Override the default list of associated filetypes for the server
--     --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
--     --  - settings (table): Override the default settings passed when initializing the server.
--     --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
--     local servers = {
--       -- clangd = {},
--       -- gopls = {},
--       -- pyright = {},
--       -- rust_analyzer = {},
--       -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
--       --
--       -- Some languages (like typescript) have entire language plugins that can be useful:
--       --    https://github.com/pmizio/typescript-tools.nvim
--       --
--       -- But for many setups, the LSP (`ts_ls`) will work just fine
--       -- ts_ls = {},
--       --
--
--       lua_ls = {
--         -- cmd = { ... },
--         -- filetypes = { ... },
--         -- capabilities = {},
--         settings = {
--           Lua = {
--             completion = {
--               callSnippet = 'Replace',
--             },
--             -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
--             -- diagnostics = { disable = { 'missing-fields' } },
--             -- diagnostics = {
--             --   globals = {
--             --     'vim',
--             --     'require',
--             --   },
--             -- },
--           },
--         },
--       },
--     }
--
--     -- Ensure the servers and tools above are installed
--     --
--     -- To check the current status of installed tools and/or manually install
--     -- other tools, you can run
--     --    :Mason
--     --
--     -- You can press `g?` for help in this menu.
--     --
--     -- `mason` had to be setup earlier: to configure its options see the
--     -- `dependencies` table for `nvim-lspconfig` above.
--     --
--     -- You can add other tools here that you want Mason to install
--     -- for you, so that they are available from within Neovim.
--     -- vim.lsp.config('lua_ls', { settings = { diagnostics = { globals = { 'vim' } } } })
--     -- require('lspconfig').gdscript.setup { capabilities = capabilities }
--     -- local ensure_installed = vim.tbl_keys(servers or {})
--     -- vim.list_extend(ensure_installed, {
--     --   'stylua', -- Used to format Lua code
--     -- })
--     -- require('mason-tool-installer').setup { ensure_installed = ensure_installed }
--     --
--     require('mason-lspconfig').setup {
--       ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
--       automatic_installation = false,
--       handlers = {
--         function(server_name)
--           -- local server = servers[server_name] or {}
--           -- -- This handles overriding only values explicitly passed
--           -- -- by the server configuration above. Useful when disabling
--           -- -- certain features of an LSP (for example, turning off formatting for ts_ls)
--           -- server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
--           --
--           -- vim.lsp.config(server_name, server)
--           -- require('lspconfig')[server_name].setup(server)
--         end,
--       },
--     }
--   end,
-- }
