return {
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
    },
    -- uncomment the following line to load hub lazily
    --cmd = "MCPHub",  -- lazy load
    build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
    -- uncomment this if you don't want mcp-hub to be available globally or can't use -g
    -- build = "bundled_build.lua",  -- Use this and set use_bundled_binary = true in opts  (see Advanced configuration)
    config = function()
      require("mcphub").setup {
        extensions = {
          avante = {
            make_slash_commands = true, -- make /slash commands from MCP server prompts
          },
        },
        servers = {
          -- SuperMemory MCP - Persistent memory and knowledge management
          supermemory = {
            command = "npx",
            args = { "@supermemory/mcp-server" },
            env = {
              -- Set environment variables if needed
              -- SUPERMEMORY_API_KEY = os.getenv("SUPERMEMORY_API_KEY") or "",
            },
            auto_approve = false, -- Manual approval for safety
          },
          
          -- Filesystem operations - Essential for file management
          filesystem = {
            command = "npx",
            args = { "@modelcontextprotocol/server-filesystem", "/home/dreamaster" },
            auto_approve = true, -- Safe for basic file operations
          },
          
          -- Git operations - Version control integration
          git = {
            command = "npx",
            args = { "@modelcontextprotocol/server-git", "--repository", vim.fn.getcwd() },
            auto_approve = false, -- Manual approval for git operations
          },
          
          -- Web search capabilities
          web_search = {
            command = "npx",
            args = { "@modelcontextprotocol/server-brave-search" },
            env = {
              BRAVE_API_KEY = os.getenv("BRAVE_API_KEY") or "",
            },
            auto_approve = false, -- Manual approval for web searches
          },
          
          -- SQLite database operations
          sqlite = {
            command = "npx",
            args = { "@modelcontextprotocol/server-sqlite", "--db-path", vim.fn.getcwd() .. "/data.db" },
            auto_approve = false, -- Manual approval for database operations
          },
          
          -- GitHub integration
          github = {
            command = "npx",
            args = { "@modelcontextprotocol/server-github" },
            env = {
              GITHUB_PERSONAL_ACCESS_TOKEN = os.getenv("GITHUB_TOKEN") or "",
            },
            auto_approve = false, -- Manual approval for GitHub operations
          },
          
          -- Terminal/shell operations
          shell = {
            command = "npx",
            args = { "@modelcontextprotocol/server-shell" },
            auto_approve = false, -- Manual approval for shell commands
          },
          
          -- Memory management (alternative to supermemory)
          memory = {
            command = "npx",
            args = { "@modelcontextprotocol/server-memory" },
            auto_approve = true, -- Safe for memory operations
          },
          
          -- Time and scheduling
          time = {
            command = "npx",
            args = { "@modelcontextprotocol/server-time" },
            auto_approve = true, -- Safe for time operations
          },
        },
        
        -- Global auto-approval settings
        auto_approve_global = false, -- Require manual approval by default
        
        -- UI settings
        ui = {
          auto_start_servers = { "filesystem", "memory", "time" }, -- Auto-start safe servers
          show_server_status = true,
          keymaps = {
            toggle_server = "t",
            toggle_auto_approve = "a",
            refresh = "r",
            quit = "q",
          },
        },
      }
    end,
  },
}
