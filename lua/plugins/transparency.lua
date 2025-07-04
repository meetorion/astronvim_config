-- Transparency configuration plugin
return {
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    config = function()
      require("transparent").setup({
        groups = {
          'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
          'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
          'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
          'SignColumn', 'CursorLine', 'CursorLineNr', 'StatusLine', 'StatusLineNC',
          'EndOfBuffer',
        },
        extra_groups = {
          "NormalFloat", -- plugins which have float panel such as Lazy, Mason, LspInfo
          "NvimTreeNormal", -- NvimTree
          "NeoTreeNormal", "NeoTreeNormalNC", -- Neo-tree
          "TelescopeNormal", "TelescopeBorder", "TelescopePromptNormal", 
          "TelescopeResultsNormal", "TelescopePreviewNormal", -- Telescope
          "WhichKeyFloat", -- WhichKey
          "LspInfoBorder", -- LspInfo
          "Mason", "MasonNormal", -- Mason
          "TabLine", "TabLineFill", "TabLineSel", -- Tabline
          "BufferLineTab", "BufferLineTabSelected", "BufferLineTabClose", -- BufferLine
          "BufferLineFill", "BufferLineBackground", "BufferLineSeparator",
          "Pmenu", "PmenuSel", "PmenuSbar", "PmenuThumb", -- Popup menu
        },
        exclude_groups = {}, -- table: groups you don't want to clear
      })
      
      -- Set initial transparency state
      require("transparent").clear_prefix("Buffer")
      require("transparent").clear_prefix("NeoTree")
      require("transparent").clear_prefix("lualine")
    end,
  }
}