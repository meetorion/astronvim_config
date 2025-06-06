return {
  {
    "vernette/ai-commit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("ai-commit").setup {
        {
          openrouter_api_key = os.getenv "OPENROUTER_API_KEY", -- or set OPENROUTER_API_KEY environment variable
          -- model = "qwen/qwen-2.5-72b-instruct:free", -- default model
          -- model = "anthropic/claude-3.5-sonnet",
          model = "microsoft/phi-3-mini-128k-instruct",
          auto_push = true, -- whether to automatically push after commit
        },
      }
    end,
  },
}
