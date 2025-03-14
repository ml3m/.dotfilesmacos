require("obsidian").setup({
  workspaces = {
    {
        name = "main",
        path = "/Users/mlem/Library/Mobile Documents/iCloud~md~obsidian/Documents/main",
      },
  },
  notes_subdir = "inbox",
  new_notes_location = "notes_subdir",


  disable_frontmatter = true,
  templates = {
      subdir = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M:%S",
  },

  -- key mappings, below are the defaults
  mappings = {
    -- overrides the 'gf' mapping to work on markdown/wiki links within your vault
    ["gf"] = {
      action = function()
        return require("obsidian").util.gf_passthrough()
      end,
      opts = { noremap = false, expr = true, buffer = true },
    },
  },

  completion = {
    nvim_cmp = true,
    min_chars = 2,
  },
  ui = {
    -- Disable some things below here because I set these manually for all Markdown files using treesitter
    checkboxes = { },
    bullets = {  },
  },
})
