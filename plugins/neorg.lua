return {
  "nvim-neorg/neorg",
  build = ":Neorg sync-parsers",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "laher/neorg-exec" },
    { "pysan3/neorg-templates", dependencies = { "L3MON4D3/LuaSnip" } },
  },
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
            work = "~/Repos/dotfile/obsidian/work",
          },
        },
      },
      ["core.summary"] = {},
      ["core.ui"] = {},
      ["external.templates"] = {
        config = {
          templates_dir = "~/Repos/dotfile/obsidian/work/journal/templates",
        },
        -- templates_dir = vim.fn.stdpath("config") .. "/templates/norg",
        -- default_subcommand = "add", -- or "fload", "load"
        -- keywords = { -- Add your own keywords.
        --   EXAMPLE_KEYWORD = function ()
        --     return require("luasnip").insert_node(1, "default text blah blah")
        --   end,
        -- },
        -- snippets_overwrite = {},
      },
      ["external.exec"] = {},
      -- ["external.kanban"] = {},
    },
  },
}
