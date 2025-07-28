-- Fix tab display issues in Neovim
local M = {}

function M.setup_tab_display()
  -- Better tab settings
  vim.opt.tabstop = 2        -- A tab is 2 spaces
  vim.opt.softtabstop = 2    -- When hitting <BS>, pretend like a tab is removed even if spaces
  vim.opt.shiftwidth = 2     -- Number of spaces to use for autoindenting  
  vim.opt.expandtab = true   -- Use spaces instead of tabs
  vim.opt.smarttab = true    -- Use 'shiftwidth' when inserting <Tab>
  
  -- Better indentation
  vim.opt.autoindent = true
  vim.opt.smartindent = true
  
  -- Show whitespace characters clearly
  vim.opt.list = true
  vim.opt.listchars = {
    tab = "→ ",      -- Show tabs as →
    trail = "•",     -- Show trailing spaces as •
    extends = "⟩",   -- Show line extends
    precedes = "⟨",  -- Show line precedes  
    nbsp = "⦸"       -- Show non-breaking spaces
  }
  
  -- Better tab line display
  vim.opt.showtabline = 2  -- Always show tabline
  
  -- Fix any transparency issues affecting tabs
  local function fix_tab_highlights()
    -- Get current colorscheme
    local colorscheme = vim.g.colors_name or "default"
    
    -- Define better tab highlights that work with transparency
    local tab_highlights = {
      TabLine = { 
        fg = "#abb2bf", 
        bg = "NONE", 
        underline = true,
        sp = "#3e4451"  -- Subtle underline for separation
      },
      TabLineFill = { 
        fg = "#5c6370", 
        bg = "NONE" 
      },
      TabLineSel = { 
        fg = "#ffffff", 
        bg = "#3e4451", 
        bold = true 
      },
      -- Also fix buffer line if using heirline
      StatusLine = {
        fg = "#abb2bf",
        bg = "NONE"
      }
    }
    
    for name, opts in pairs(tab_highlights) do
      vim.api.nvim_set_hl(0, name, opts)
    end
  end
  
  -- Apply highlight fixes immediately and on colorscheme change
  fix_tab_highlights()
  
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = fix_tab_highlights,
    desc = "Fix tab highlights after colorscheme change"
  })
  
  print("✅ Tab display settings fixed!")
end

-- Auto-run the fix
M.setup_tab_display()

return M