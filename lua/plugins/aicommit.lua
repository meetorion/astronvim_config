return {
  {
    "meetorion/ai-commit.nvim",
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
          -- model = "deepseek/deepseek-chat-v3-0324",
          model = "google/gemini-flash-1.5-8b",
          -- model = "microsoft/phi-3-mini-128k-instruct",
          auto_push = true, -- whether to automatically push after commit
          commit_template = [[
You are a senior software engineer creating commit messages.

Analyze this git diff and create 5 concise commit messages following these rules:
1. Use imperative mood (e.g., "Add feature" not "Added feature")
2. Keep the first line under 50 characters
3. Focus on the "why" not the "what"
4. Use conventional commit format: type(scope): description

Git diff:
%s

Recent commits for context:
%s

Generate exactly 5 commit messages following the above guidelines:
    ]],
        },
      }
    end,
  },
}
