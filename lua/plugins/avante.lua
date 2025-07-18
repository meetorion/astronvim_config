return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false, -- set this if you want to always pull the latest change
  -- Pin to a specific commit to avoid unstable versions
  -- commit = "stable", -- uncomment and update if needed
  -- system_prompt as function ensures LLM always has latest MCP server state
  -- This is evaluated for every message, even in existing chats
  system_prompt = function()
    local hub = require("mcphub").get_hub_instance()
    return hub and hub:get_active_servers_prompt() or ""
  end,
  -- Using function prevents requiring mcphub before it's loaded
  custom_tools = function()
    return {
      require("mcphub.extensions.avante").mcp_tool(),
    }
  end,
  opts = {
    provider = "deepseek_chat",
    -- provider = "copilot",
    cursor_applying_provider = "deepseek_chat", -- In this example, use Groq for applying, but you can also use any provider you want.
    -- auto_suggestions_provider = "copilot", -- In",
    behaviour = {
      --- ... existing behaviours
      ---
      auto_approve_tool_permissions = true,
      enable_cursor_planning_mode = true, -- enable cursor planning mode!
      auto_suggestions = false,
    },
    ui = {
      -- Fix spinner related issues
      spinner = {
        enabled = true,
        frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
        interval = 80,
      },
    },
    providers = {
      aihubmix = {
        model = "claude-sonnet-4-20250514",
      },
      openrouter = {
        __inherited_from = "openai",
        endpoint = "https://openrouter.ai/api/v1",
        api_key_name = "OPENROUTER_API_KEY",
        -- model = "deepseek/deepseek-r1",
        -- model = "anthropic/claude-3.5-sonnet",
        -- model = "anthropic/claude-opus-4",
        model = "anthropic/claude-sonnet-4",
      },
      deepseek_reasoner = {
        __inherited_from = "openai",
        api_key_name = "DEEPSEEK_API_KEY",
        endpoint = "https://api.deepseek.com",
        model = "deepseek-reasoner",
      },
      deepseek_chat = {
        __inherited_from = "openai",
        api_key_name = "DEEPSEEK_API_KEY",
        endpoint = "https://api.deepseek.com",
        model = "deepseek-chat",
      },
    },
    rag_service = {                     -- RAG Service configuration
      enabled = false,                  -- Enables the RAG service
      host_mount = os.getenv "HOME",    -- Host mount path for the rag service (Docker will mount this path)
      runner = "docker",                -- Runner for the RAG service (can use docker or nix)
      llm = {                           -- Language Model (LLM) configuration for RAG service
        provider = "openrouter",        -- LLM provider
        endpoint = "https://openrouter.ai/api/v1",
        api_key = "OPENROUTER_API_KEY", -- Environment variable name for the LLM API key
        model = "anthropic/claude-sonnet-4",
        extra = nil,                    -- Additional configuration options for LLM
      },
      embed = {                         -- Embedding model configuration for RAG service
        provider = "openrouter",        -- LLM provider
        endpoint = "https://openrouter.ai/api/v1",
        api_key = "OPENROUTER_API_KEY", -- Environment variable name for the LLM API key
        model = "anthropic/claude-sonnet-4",
        -- provider = "openai", -- Embedding provider
        -- endpoint = "https://api.openai.com/v1", -- Embedding API endpoint
        -- api_key = "OPENAI_API_KEY", -- Environment variable name for the embedding API key
        -- model = "text-embedding-3-large", -- Embedding model name
        extra = nil,          -- Additional configuration options for the embedding model
      },
      docker_extra_args = "", -- Extra arguments to pass to the docker command
    },
    disabled_tools = {
      "list_files", -- Built-in file operations
      "search_files",
      "read_file",
      "create_file",
      "rename_file",
      "delete_file",
      "create_dir",
      "rename_dir",
      "delete_dir",
      -- "bash", -- Built-in terminal access
    },
    {
      custom_tools = {
        {
          name = "run_go_tests",                                -- Unique name for the tool
          description = "Run Go unit tests and return results", -- Description shown to AI
          command = "go test -v ./...",                         -- Shell command to execute
          param = {                                             -- Input parameters (optional)
            type = "table",
            fields = {
              {
                name = "target",
                description = "Package or directory to test (e.g. './pkg/...' or './internal/pkg')",
                type = "string",
                optional = true,
              },
            },
          },
          returns = { -- Expected return values
            {
              name = "result",
              description = "Result of the fetch",
              type = "string",
            },
            {
              name = "error",
              description = "Error message if the fetch was not successful",
              type = "string",
              optional = true,
            },
          },
          func = function(params, on_log, on_complete) -- Custom function to execute
            local target = params.target or "./..."
            return vim.fn.system(string.format("go test -v %s", target))
          end,
        },
      },
    },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows

  config = function(_, opts)
    -- Apply temporary fix for spinner_char error
    pcall(require, "avante_fix")

    -- Safe setup with error handling
    local ok, avante = pcall(require, "avante")
    if not ok then
      vim.notify("Failed to load avante.nvim", vim.log.levels.ERROR)
      return
    end

    -- Setup with safe defaults
    local safe_opts = vim.tbl_deep_extend("force", {
      -- Ensure spinner is properly configured
      ui = {
        spinner = {
          enabled = true,
          frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
          interval = 80,
        },
      },
    }, opts or {})

    avante.setup(safe_opts)

    -- Apply fix after setup as well
    vim.defer_fn(function() pcall(require, "avante_fix") end, 100)
  end,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "zbirenbaum/copilot.lua",      -- for providers='copilot'
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
