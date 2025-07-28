-- Toggle gitignored files visibility in NeoTree
local M = {}

-- State tracking
M.show_gitignored = true

function M.toggle()
  M.show_gitignored = not M.show_gitignored
  
  -- Update NeoTree configuration
  require("neo-tree").setup({
    filesystem = {
      hide_gitignored = not M.show_gitignored,
      filtered_items = {
        visible = M.show_gitignored,
        hide_gitignored = not M.show_gitignored,
        hide_dotfiles = false,
        always_show = {
          ".gitignore",
          ".env",
          ".env.example", 
          "docs"
        },
      }
    }
  })
  
  -- Refresh the tree
  vim.cmd("Neotree refresh")
  
  -- Show status
  if M.show_gitignored then
    print("✅ NeoTree: Now showing gitignored files")
  else
    print("🚫 NeoTree: Now hiding gitignored files") 
  end
end

function M.show()
  M.show_gitignored = true
  M.toggle()
  M.toggle() -- Double toggle to ensure state
end

function M.hide()
  M.show_gitignored = false
  M.toggle()
  M.toggle() -- Double toggle to ensure state
end

-- Auto-run to show gitignored files by default
M.show()

return M