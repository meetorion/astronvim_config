return {
  dir = "~/work/ai-commit.nvim", -- Path to your local clone
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("ai-commit").setup {
      api_provider = "deepseek",
      deepseek_api_key = vim.env.DEEPSEEK_API_KEY,
      model = "deepseek-chat",
      language = "zh",
      auto_push = false,

      -- openrouter_api_key = vim.env.OPENROUTER_API_KEY,
      -- language = "zh",
    }
  end,
}
