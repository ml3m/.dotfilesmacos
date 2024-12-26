require('orgmode').setup({
  org_agenda_files = {'~/Library/Mobile Documents/com~apple~CloudDocs/main/TODO/org/*', '~/my-orgs/**/*'},
  org_default_notes_file = '~/Dropbox/org/notes.org',
  org_todo_keywords = {'TODO', 'IN-PROGRESS', 'REVIEW', '|', 'DONE', 'CANCELED' },

  org_log_done = 'note',
  org_log_into_drawer = 'LOGBOOK',

  mappings = {
    global = {
      org_agenda = 'gA',
      org_capture = 'gC'
    },
  },
})
