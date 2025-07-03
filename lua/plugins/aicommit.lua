return {
  "meetorion/ai-commit.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim", -- optional, for interactive features
  },
  config = function()
    require("ai-commit").setup {
      -- Claude CLI配置（默认启用）
      use_claude_cli = true,      -- 默认值
      claude_cli_config = {
        model = "sonnet",         -- sonnet (推荐) | opus | haiku
        fallback_model = "haiku", -- 快速备用模型
        timeout = 30000,
        debug = false,
      },
    }
  end,
}
