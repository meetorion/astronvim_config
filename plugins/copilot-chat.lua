-- local IS_DEV = false

local prompts = {
  -- Code related prompts
  Explain = "Please use chinese explain how the following code works.用中文回复我.",
  Review = "Please use chinese review the following code and provide suggestions for improvement.",
  Tests = "Please use chinese explain how the selected code works, then generate unit tests for it.用中文回复我.",
  Refactor = "Please use chinese refactor the following code to improve its clarity and readability.用中文回复我.",
  -- Text related prompts
  Summarize = "Please summarize the following text.用中文回复我.",
  Spelling = "Please correct any grammar and spelling errors in the following text.用中文回复我.",
  Wording = "Please improve the grammar and wording of the following text.用中文回复我.",
  Concise = "Please rewrite the following text to make it more concise.用中文回复我.",
}

return {
  -- Import the copilot plugin
  -- { import = "lazyvim.plugins.extras.coding.copilot" },
  {
    -- dir = IS_DEV and "~/Projects/research/CopilotChat.nvim" or nil,
    "jellydn/CopilotChat.nvim",
    opts = {
      mode = "split",
      prompts = prompts,
    },
    build = function()
      vim.defer_fn(function()
        vim.cmd "UpdateRemotePlugins"
        vim.notify "CopilotChat - Updated remote plugins. Please restart Neovim."
      end, 3000)
    end,
    event = "VeryLazy",
    keys = {
      { "<leader>cce", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
      { "<leader>cct", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
      { "<leader>ccr", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
      { "<leader>ccR", "<cmd>CopilotChatRefactor<cr>", desc = "CopilotChat - Refactor code" },
      { "<leader>ccs", "<cmd>CopilotChatSummarize<cr>", desc = "CopilotChat - Summarize text" },
      { "<leader>ccS", "<cmd>CopilotChatSpelling<cr>", desc = "CopilotChat - Correct spelling" },
      { "<leader>ccw", "<cmd>CopilotChatWording<cr>", desc = "CopilotChat - Improve wording" },
      { "<leader>ccc", "<cmd>CopilotChatConcise<cr>", desc = "CopilotChat - Make text concise" },
    },
  },
}
