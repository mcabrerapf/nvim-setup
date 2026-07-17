local gh = require("utils.gh")
vim.pack.add({ gh("nvim-orgmode/orgmode") })

require('orgmode').setup({
    org_agenda_files = '~/orgfiles/**/*',
    org_default_notes_file = '~/orgfiles/refile.org',
})
