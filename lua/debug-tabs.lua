-- Tab display diagnostic script
local M = {}

function M.diagnose_tabs()
  print("=== Neovim Tab Display Diagnosis ===")
  
  -- Basic tab settings
  print("\n1. Basic Tab Settings:")
  print("  tabstop:", vim.opt.tabstop:get())
  print("  softtabstop:", vim.opt.softtabstop:get())
  print("  shiftwidth:", vim.opt.shiftwidth:get())
  print("  expandtab:", vim.opt.expandtab:get())
  print("  showtabline:", vim.opt.showtabline:get())
  
  -- GUI/Terminal detection
  print("\n2. Environment:")
  print("  has GUI:", vim.fn.has('gui_running'))
  print("  TERM:", vim.env.TERM or "unknown")
  print("  TERM_PROGRAM:", vim.env.TERM_PROGRAM or "unknown")
  print("  COLORTERM:", vim.env.COLORTERM or "unknown")
  
  -- Buffer/Tab information
  print("\n3. Current Buffer/Tab Info:")
  print("  Current buffer:", vim.fn.bufnr('%'))
  print("  Buffer name:", vim.fn.bufname('%'))
  print("  Buffer type:", vim.bo.buftype)
  print("  File type:", vim.bo.filetype)
  print("  Number of tabs:", vim.fn.tabpagenr('$'))
  print("  Current tab:", vim.fn.tabpagenr())
  
  -- Tabline function check
  print("\n4. Tabline Settings:")
  print("  tabline option:", vim.opt.tabline:get())
  if vim.opt.tabline:get() ~= "" then
    print("  Custom tabline function detected")
  end
  
  -- Check for buffer/tabline plugins
  print("\n5. Buffer/Tab Plugins:")
  local plugins_to_check = {
    "bufferline.nvim",
    "barbar.nvim", 
    "tabby.nvim",
    "vim-airline",
    "lualine.nvim"
  }
  
  for _, plugin in ipairs(plugins_to_check) do
    local ok = pcall(require, plugin)
    if ok then
      print("  Found:", plugin)
    end
  end
  
  -- Check AstroNvim specific components
  print("\n6. AstroNvim Components:")
  local astro_ok, astroui = pcall(require, "astroui")
  if astro_ok then
    print("  AstroUI loaded: yes")
  else
    print("  AstroUI loaded: no")
  end
  
  local heirline_ok, heirline = pcall(require, "heirline")
  if heirline_ok then
    print("  Heirline loaded: yes")
  else
    print("  Heirline loaded: no")
  end
  
  -- Check transparency settings
  print("\n7. Transparency Settings:")
  local highlights_to_check = {"TabLine", "TabLineFill", "TabLineSel"}
  for _, hl in ipairs(highlights_to_check) do
    local ok, hl_def = pcall(vim.api.nvim_get_hl_by_name, hl, true)
    if ok then
      print(string.format("  %s: bg=%s, fg=%s", hl, hl_def.background or "NONE", hl_def.foreground or "default"))
    end
  end
  
  print("\n=== End Diagnosis ===")
end

-- Auto-run diagnosis
M.diagnose_tabs()

return M