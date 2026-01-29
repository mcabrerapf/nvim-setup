return {
  'TheNoeTrevino/haunt.nvim',
  -- default config: change to your liking, or remove it to use defaults
  ---@class HauntConfig
  opts = {
    sign = '󱙝',
    sign_hl = 'DiagnosticInfo',
    virt_text_hl = 'HauntAnnotation', -- links to DiagnosticVirtualTextHint
    annotation_prefix = ' 󰆉 ',
    line_hl = nil,
    virt_text_pos = 'eol',
    data_dir = nil,
    per_branch_bookmarks = true,
    picker = 'auto', -- "auto", "snacks", "telescope", or "fzf"
    picker_keys = { -- picker agnostic, we got you covered
      delete = { key = 'd', mode = { 'n' } },
      edit_annotation = { key = 'a', mode = { 'n' } },
    },
  },
  -- recommended keymaps, with a helpful prefix alias
  init = function()
    local haunt = require 'haunt.api'
    local haunt_picker = require 'haunt.picker'
    local map = vim.keymap.set
    local prefix = '<leader>a'

    -- annotations
    map('n', prefix .. 'a', function()
      haunt.annotate()
    end, { desc = '[a]nnotate' })

    map('n', prefix .. 't', function()
      haunt.toggle_annotation()
    end, { desc = '[t]oggle annotation' })

    map('n', prefix .. 'T', function()
      haunt.toggle_all_lines()
    end, { desc = '[T]oggle all annotations' })

    map('n', prefix .. 'd', function()
      haunt.delete()
    end, { desc = '[d]elete annotation' })

    map('n', prefix .. 'D', function()
      haunt.clear_all()
    end, { desc = '[D]elete all annotations' })

    -- move
    map('n', prefix .. 'k', function()
      haunt.prev()
    end, { desc = 'Previous annotation' })

    map('n', prefix .. 'j', function()
      haunt.next()
    end, { desc = 'Next annotation' })

    -- picker
    map('n', prefix .. 'l', function()
      haunt_picker.show()
    end, { desc = 'Show Picker' })

    -- quickfix
    -- map('n', prefix .. 'q', function()
    --   haunt.to_quickfix()
    -- end, { desc = 'Send Hauntings to QF Lix (buffer)' })
    --
    -- map('n', prefix .. 'Q', function()
    --   haunt.to_quickfix { current_buffer = true }
    -- end, { desc = 'Send Hauntings to QF Lix (all)' })

    -- yank
    map('n', prefix .. 'y', function()
      haunt.yank_locations { current_buffer = true }
    end, { desc = 'Send Hauntings to Clipboard (buffer)' })

    map('n', prefix .. 'Y', function()
      haunt.yank_locations()
    end, { desc = 'Send Hauntings to Clipboard (all)' })
  end,
}
