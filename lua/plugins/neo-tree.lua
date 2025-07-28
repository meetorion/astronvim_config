-- Neo-tree configuration with better gitignore handling
-- This makes development more friendly by showing gitignored files

return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      -- Show gitignored files by default (better for development)
      hide_gitignored = false,
      
      -- Show hidden files (files starting with .)
      hide_hidden = false,
      
      -- More inclusive file filtering
      filtered_items = {
        visible = true, -- Show filtered items with different highlighting
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = {
          -- Only hide these specific files/folders that are truly noise
          ".git",
          "node_modules",
          ".DS_Store",
          "thumbs.db"
        },
        hide_by_pattern = {
          -- Hide patterns that are usually noise
          "*.tmp",
          "*.cache"
        },
        always_show = {
          -- Always show these even if they match hide patterns
          ".gitignore",
          ".env",
          ".env.example",
          "docs"
        },
        never_show = {
          -- Never show these (truly useless files)
          ".git",
          "thumbs.db"
        },
      },
      
      -- Follow current file in tree
      follow_current_file = {
        enabled = true,
        leave_dirs_open = false,
      },
      
      -- Use system commands for file operations
      use_libuv_file_watcher = true,
      
      -- Hijack netrw
      hijack_netrw_behavior = "open_current",
    },
    
    -- Window options
    window = {
      position = "left",
      width = 35,
      mapping_options = {
        noremap = true,
        nowait = true,
      },
      mappings = {
        -- Add toggle for gitignored files
        ["I"] = "toggle_hidden",
        ["H"] = "toggle_hidden",
        -- Add refresh
        ["R"] = "refresh",
        -- Add git status toggle
        ["g"] = {
          "toggle_git_status",
          desc = "Toggle git status"
        },
      },
    },
    
    -- Default component configs
    default_component_configs = {
      indent = {
        indent_size = 2,
        padding = 1,
        with_markers = true,
        indent_marker = "│",
        last_indent_marker = "└",
        highlight = "NeoTreeIndentMarker",
        with_expanders = nil,
        expander_collapsed = "",
        expander_expanded = "",
        expander_highlight = "NeoTreeExpander",
      },
      icon = {
        folder_closed = "",
        folder_open = "",
        folder_empty = "",
        default = "*",
        highlight = "NeoTreeFileIcon"
      },
      modified = {
        symbol = "[+]",
        highlight = "NeoTreeModified",
      },
      name = {
        trailing_slash = false,
        use_git_status_colors = true,
        highlight = "NeoTreeFileName",
      },
      git_status = {
        symbols = {
          -- Change type
          added     = "✚", -- or "A", but this is redundant info if you use git_status_colors on the name
          modified  = "", -- or "M", but this is redundant info if you use git_status_colors on the name
          deleted   = "✖",-- this can only be used in the git_status source
          renamed   = "",-- this can only be used in the git_status source
          -- Status type
          untracked = "",
          ignored   = "",
          unstaged  = "",
          staged    = "",
          conflict  = "",
        }
      },
    },
    
    -- Git status integration
    source_selector = {
      winbar = false,
      statusline = false,
      sources = {
        { source = "filesystem" },
        { source = "git_status" },
        { source = "buffers" },
      },
    },
  },
  
  config = function(_, opts)
    -- Apply the configuration
    require("neo-tree").setup(opts)
    
    -- Add some helpful commands
    vim.api.nvim_create_user_command("NeotreeShowGitignored", function()
      require("neo-tree").setup({
        filesystem = {
          filtered_items = {
            hide_gitignored = false,
            visible = true,
          }
        }
      })
      vim.cmd("Neotree refresh")
    end, { desc = "Show gitignored files in Neotree" })
    
    vim.api.nvim_create_user_command("NeotreeHideGitignored", function()
      require("neo-tree").setup({
        filesystem = {
          filtered_items = {
            hide_gitignored = true,
            visible = false,
          }
        }
      })
      vim.cmd("Neotree refresh")
    end, { desc = "Hide gitignored files in Neotree" })
  end,
}