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
          openrouter_api_key = os.getenv "OPENAI_API_KEY", -- or set OPENROUTER_API_KEY environment variable
          model = "qwen/qwen-2.5-72b-instruct:free", -- default model
          auto_push = false, -- whether to automatically push after commit
        },
      }
    end,
  },
}
