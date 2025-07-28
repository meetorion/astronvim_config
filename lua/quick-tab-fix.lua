-- Quick fix for tab display issues
-- Run this with :lua require('quick-tab-fix')

-- Apply immediate fixes
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Show whitespace clearly
vim.opt.list = true
vim.opt.listchars = {
  tab = "→ ",      -- Show tabs as →
  trail = "•",     -- Show trailing spaces as •
  extends = "⟩",   -- Show line extends
  precedes = "⟨",  -- Show line precedes
  nbsp = "⦸"       -- Show non-breaking spaces
}

-- Ensure tabline is always shown
vim.opt.showtabline = 2

-- Fix tab highlights immediately
local tab_highlights = {
  TabLine = { 
    fg = "#abb2bf", 
    bg = "NONE", 
    underline = true,
    sp = "#3e4451"
  },
  TabLineFill = { 
    fg = "#5c6370", 
    bg = "NONE" 
  },
  TabLineSel = { 
    fg = "#ffffff", 
    bg = "#3e4451", 
    bold = true 
  }
}

for name, opts in pairs(tab_highlights) do
  vim.api.nvim_set_hl(0, name, opts)
end

print("✅ Tab display fixed! You should see:")
print("  - Tabs shown as → with proper spacing")
print("  - Trailing spaces shown as •")
print("  - Better tab line visibility")
print("  - Consistent 2-space indentation")

-- Show current settings for verification
print("\n📊 Current settings:")
print("  tabstop:", vim.opt.tabstop:get())
print("  softtabstop:", vim.opt.softtabstop:get())
print("  shiftwidth:", vim.opt.shiftwidth:get())
print("  expandtab:", vim.opt.expandtab:get())
print("  list:", vim.opt.list:get())