return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false, -- set this if you want to always pull the latest change
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
    -- provider = "deepseek",
    provider = "openrouter",
    cursor_applying_provider = "openrouter", -- In this example, use Groq for applying, but you can also use any provider you want.
    auto_suggestions_provider = "openrouter",
    behaviour = {
      --- ... existing behaviours
      enable_cursor_planning_mode = true, -- enable cursor planning mode!
      auto_suggestions = false,
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
        model = "deepseek-reasoner",
      },
    },
    rag_service = { -- RAG Service configuration
      enabled = false, -- Enables the RAG service
      host_mount = os.getenv "HOME", -- Host mount path for the rag service (Docker will mount this path)
      runner = "docker", -- Runner for the RAG service (can use docker or nix)
      llm = { -- Language Model (LLM) configuration for RAG service
        provider = "openrouter", -- LLM provider
        endpoint = "https://openrouter.ai/api/v1",
        api_key = "OPENROUTER_API_KEY", -- Environment variable name for the LLM API key
        model = "anthropic/claude-sonnet-4",
        extra = nil, -- Additional configuration options for LLM
      },
      embed = { -- Embedding model configuration for RAG service
        provider = "openrouter", -- LLM provider
        endpoint = "https://openrouter.ai/api/v1",
        api_key = "OPENROUTER_API_KEY", -- Environment variable name for the LLM API key
        model = "anthropic/claude-sonnet-4",
        -- provider = "openai", -- Embedding provider
        -- endpoint = "https://api.openai.com/v1", -- Embedding API endpoint
        -- api_key = "OPENAI_API_KEY", -- Environment variable name for the embedding API key
        -- model = "text-embedding-3-large", -- Embedding model name
        extra = nil, -- Additional configuration options for the embedding model
      },
      docker_extra_args = "", -- Extra arguments to pass to the docker command
    },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "zbirenbaum/copilot.lua", -- for providers='copilot'
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
