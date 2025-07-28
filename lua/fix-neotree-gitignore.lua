-- Immediate fix for NeoTree gitignore visibility
-- Run this with :lua require('fix-neotree-gitignore')

local function setup_neotree_gitignore()
  -- Check if neo-tree is available
  local ok, neotree = pcall(require, "neo-tree")
  if not ok then
    print("❌ Neo-tree not found, skipping gitignore fix")
    return
  end
  
  -- Configure to show gitignored files
  neotree.setup({
    filesystem = {
      hide_gitignored = false,
      hide_hidden = false,
      filtered_items = {
        visible = true, -- Show filtered items with different highlighting
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = {
          -- Only hide truly useless files
          ".git",
          "node_modules", 
          ".DS_Store",
          "thumbs.db"
        },
        always_show = {
          -- Always show important files
          ".gitignore",
          ".env",
          ".env.example",
          "docs",
          "README.md"
        },
        never_show = {
          ".git"
        },
      },
      follow_current_file = {
        enabled = true,
      },
    },
    window = {
      mappings = {
        ["I"] = "toggle_hidden",
        ["H"] = "toggle_hidden", 
        ["R"] = "refresh",
      },
    },
    default_component_configs = {
      git_status = {
        symbols = {
          added     = "✚",
          modified  = "",
          deleted   = "✖",
          renamed   = "",
          untracked = "",
          ignored   = "◌", -- Show ignored files with a different symbol
          unstaged  = "",
          staged    = "",
          conflict  = "",
        }
      },
    },
  })
  
  -- Refresh if neo-tree is open
  pcall(function()
    vim.cmd("Neotree refresh")
  end)
  
  print("✅ NeoTree configured to show gitignored files!")
  print("📁 Your docs/ folder should now be visible")
  print("💡 Use <Leader>ug to toggle gitignored files visibility")
  print("💡 Use 'I' or 'H' in NeoTree to toggle hidden files")
end

setup_neotree_gitignore()

return { setup = setup_neotree_gitignore }