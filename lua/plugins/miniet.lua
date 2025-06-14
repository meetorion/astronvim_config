return {
  {
    "milanglacier/minuet-ai.nvim",
    config = function()
      require("minuet").setup {
        provider = "openai_compatible",
        request_timeout = 2.5,
        throttle = 1500, -- Increase to reduce costs and avoid rate limits
        debounce = 600, -- Increase to reduce costs and avoid rate limits
        provider_options = {
          openai_compatible = {
            api_key = "OPENROUTER_API_KEY",
            end_point = "https://openrouter.ai/api/v1/chat/completions",
            model = "deepseek/deepseek-chat-v3-0324",
            name = "Openrouter",
            optional = {
              max_tokens = 56,
              top_p = 0.9,
              provider = {
                -- Prioritize throughput for faster completion
                sort = "throughput",
              },
            },
          },
        },
      }
    end,
  },
  { "nvim-lua/plenary.nvim" },
  -- optional, if you are using virtual-text frontend, nvim-cmp is not
  -- required.
  {
    "hrsh7th/nvim-cmp",
    config = function()
      require("cmp").setup {
        sources = {
          {
            -- Include minuet as a source to enable autocompletion
            { name = "minuet" },
            -- and your other sources
          },
        },
        performance = {
          -- It is recommended to increase the timeout duration due to
          -- the typically slower response speed of LLMs compared to
          -- other completion sources. This is not needed when you only
          -- need manual completion.
          fetching_timeout = 2000,
        },
      }

      -- If you wish to invoke completion manually,
      -- The following configuration binds `A-y` key
      -- to invoke the configuration manually.
      require("cmp").setup {
        mapping = {
          ["<A-y>"] = require("minuet").make_cmp_map(),
          -- and your other keymappings
        },
      }
    end,
  },
  -- optional, if you are using virtual-text frontend, blink is not required.
  { "Saghen/blink.cmp" },
}
