-- Clean tab fix - remove ugly arrows
-- Run this with :lua require('clean-tab-fix')

-- Keep good tab settings but hide ugly characters
vim.opt.tabstop = 2
vim.opt.softtabstop = 2  
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- TURN OFF the ugly arrow display
vim.opt.list = false

-- Keep tabline visible but clean
vim.opt.showtabline = 2

-- Keep good tab highlights
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

print("✅ Tab display cleaned up!")
print("  - Removed ugly → arrows")  
print("  - Kept proper 2-space indentation")
print("  - Tab functionality still works perfectly")

-- Add a mapping to toggle whitespace display if needed
vim.keymap.set('n', '<leader>uw', function()
  vim.opt.list = not vim.opt.list:get()
  if vim.opt.list:get() then
    print("Whitespace visible")
  else
    print("Whitespace hidden")
  end
end, { desc = "Toggle whitespace display" })