return {
  "nvim-neorg/neorg",
  build = ":Neorg sync-parsers",
  dependencies = { "nvim-lua/plenary.nvim"},
  requires = "john-cena/cool-neorg-plugin",
  event = "VeryLazy",
  opts = {
    load = {
      ["core.defaults"] = {}, -- Loads default behaviour
      ["core.concealer"] = {}, -- Adds pretty icons to your documents
      ["core.keybinds"] = {}, -- Adds default keybindings
      ["core.completion"] = {
        config = {
          engine = "nvim-cmp",
        },
      }, -- Enables support for completion plugins
      ["core.journal"] = {}, -- Enables support for the journal module
      ["core.dirman"] = { -- Manages Neorg workspaces
        config = {
          workspaces = {
            work = "~/syncspace/obsidian/work",
          },
        },
      },
      ["core.summary"] = {}
      -- ["external.kanban"] = {},
    },
  },
}
