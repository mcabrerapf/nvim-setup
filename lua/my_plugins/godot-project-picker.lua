local create_floating_window = require 'utils.create-floating-window'
local get_directories = require 'utils.get-directories'
local get_longest_name = require 'utils.get-longest-string'

local M = {
    current_session = ''
}

local function updated_godot_session()
    if not M.current_session or M.current_session == '' then
        return
    end
    vim.cmd('mksession! ' .. M.current_session)
end

local function load_godot_session(project_path)
    M.current_session = project_path .. '/session.vim'
    vim.fn.writefile({ M.current_session }, vim.fn.stdpath("state") .. "/last_session")
    vim.api.nvim_command("silent %bd")
    if vim.fn.filereadable(M.current_session) == 1 then
        vim.cmd('source ' .. M.current_session)
    else
        vim.cmd('mksession ' .. M.current_session)
    end
end

local function start_godot_server()
    -- local target = vim.env.GODOT_SERVER_PORT
    -- local servers = vim.fn.serverlist()
    -- -- NOTE: In Godot add this in Editor Settings > External > Exec flags > --server {godo_port} --remote-send "<C-\><C-N>:wincmd l | edit {file}<CR>{line}G{col}"
    -- if vim.tbl_contains(servers, target) then
    --     vim.fn.serverstop(target)
    -- end
    -- vim.fn.serverstart(target)
end

local function open_godot(project_path)
    if vim.fn.filereadable(vim.env.GODOT_EXE_PATH) == 1 then
        vim.system({
            "cmd.exe",
            "/c",
            "start",
            "",
            vim.env.GODOT_EXE_PATH,
            "--editor",
            "--path",
            project_path,
        })
    end
end

local function get_selected_project_path()
    local line = vim.api.nvim_get_current_line()
    if line == '' then
        return ''
    end
    return vim.env.GODOT_PROJECTS_PATH .. '/' .. line
end

local function open_project(project_path)
    if project_path == '' then
        return
    end
    vim.cmd('tcd ' .. project_path)
end

local toggle_project_picker = function()
    local buf = vim.api.nvim_create_buf(false, true)
    local dirs = get_directories(vim.env.GODOT_PROJECTS_PATH)
    if #dirs < 1 then
        vim.notify("No godot projects", vim.log.levels.WARN)
        return
    end
    local longest_dir_name = get_longest_name(dirs)
    if longest_dir_name < 25 then
        longest_dir_name = 25
    end
    local height = #dirs
    if height > 15 then
        height = 15
    end
    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, dirs)
    vim.bo[buf].modifiable = false
    local win = create_floating_window { buf = buf, width = longest_dir_name, height = height, title = 'Godot Projects' }
    --
    vim.keymap.set('n', '<esc>', function()
        vim.api.nvim_win_close(win, true)
        vim.api.nvim_buf_delete(buf, { force = true })
    end, { buffer = buf })
    --
    vim.keymap.set('n', 'q', function()
        vim.api.nvim_win_close(win, true)
        vim.api.nvim_buf_delete(buf, { force = true })
    end, { buffer = buf })
    --
    vim.keymap.set('n', '<M-q>', function()
        vim.api.nvim_win_close(win, true)
        vim.api.nvim_buf_delete(buf, { force = true })
    end, { buffer = buf })
    --
    vim.keymap.set('n', '<M-e>', function()
        local project_path = get_selected_project_path()
        open_godot(project_path)
    end, { buffer = buf })
    --
    vim.keymap.set('n', '<M-l>', function()
        local project_path = get_selected_project_path()
        vim.api.nvim_win_close(win, true)
        vim.api.nvim_buf_delete(buf, { force = true })
        start_godot_server()
        open_project(project_path)
        load_godot_session(project_path)
    end, { buffer = buf })
end

local function godot_script_search()
    if vim.fn.filereadable(vim.fn.getcwd() .. '/project.godot') == 1 then
        local filename_first = require 'utils.filename-first'
        local pick = require 'mini.pick'
        local items = vim.fn.glob('**/*.gd', false, true)
        pick.start({ source = { items = items, show = filename_first, name = "Godot script search" } })
    else
        print("Cant a do gdscript search in non godot project")
    end
end

local function set_auto_commands()
    vim.api.nvim_create_autocmd('VimLeavePre', {
        callback = updated_godot_session,
    })
end

local function set_commands()
    vim.api.nvim_create_user_command('GodotProjectPickerToggle', toggle_project_picker, {})
    vim.api.nvim_create_user_command('GodotScriptSearch', godot_script_search, {})
    vim.api.nvim_create_user_command('GodotStartServer', start_godot_server, {})
    vim.api.nvim_create_user_command('GodotRestartLsp', function()
        local clients = vim.lsp.get_clients(vim.lsp.get_clients({ name = 'gdscript' }))
        for _, client in ipairs(clients) do
            client.stop(client)
        end
        vim.cmd('LspStart gdscript')
        vim.defer_fn(function()
            vim.cmd('e')
        end, 500)
        start_godot_server()
    end, {})
end

local function set_keymaps()
    vim.keymap.set('n', '<leader>fg', ':GodotProjectPickerToggle<CR>', { desc = 'Godot projects', silent = true, })
    vim.keymap.set('n', '<leader>sg', ':GodotScriptSearch<CR>', { desc = 'Search godot scripts', silent = true })
end

M.setup = function()
    -- NOTE: Make sure both godot.exe AND the projects folder are in the same drive
    if not vim.env.GODOT_SERVER_PORT or not vim.env.GODOT_PROJECTS_PATH or not vim.env.GODOT_EXE_PATH then
        return
    end
    set_auto_commands()
    set_commands()
    set_keymaps()
end

return M
