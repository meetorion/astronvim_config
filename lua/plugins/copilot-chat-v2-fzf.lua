local IS_DEV = false

local prompts = {
  -- Code related prompts
  Explain = "请用中文解释以下代码的工作原理。",
  Review = "请用中文审查以下代码并提供改进建议。",
  Tests = "请用中文解释选定代码的工作原理，然后为其生成单元测试。",
  Refactor = "请用中文重构以下代码以提高其清晰度和可读性。",
  FixCode = "请用中文修复以下代码使其按预期工作。",
  FixError = "请用中文解释以下文本中的错误并提供解决方案。",
  BetterNamings = "请用中文为以下变量和函数提供更好的名称。",
  Documentation = "请用中文为以下代码提供文档。",
  SwaggerApiDocs = "请用中文使用 Swagger 为以下 API 提供文档。",
  SwaggerJsDocs = "请用中文使用 Swagger 为以下 API 编写 JSDoc。",
  -- Text related prompts
  Summarize = "请用中文总结以下文本。",
  Spelling = "请用中文纠正以下文本中的语法和拼写错误。",
  Wording = "请用中文改进以下文本的语法和措辞。",
  Concise = "请用中文重写以下文本使其更简洁。",
}

return {
  -- { import = "plugins.extras.copilot-vim" }, -- Or use { import = "lazyvim.plugins.extras.coding.copilot" },
  -- { import = "plugins.extras.fzf" }, -- Use fzf for fuzzy finding
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>a", group = "ai" },
        { "<leader>cc", group = "Copilot Chat" },
        { "<leader>gm", group = "Copilot Chat" },
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    optional = true,
    opts = {
      file_types = { "markdown", "copilot-chat" },
    },
    ft = { "markdown", "copilot-chat" },
  },

  {
    -- dir = IS_DEV and "~/Projects/research/CopilotChat.nvim" or nil,
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    -- version = "v3.3.0", -- Use a specific version to prevent breaking changes
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    opts = {
      question_header = "## User ",
      answer_header = "## Copilot ",
      error_header = "## Error ",
      prompts = prompts,
      -- model = "claude-3.7-sonnet",
      -- 设置系统消息确保所有回复都使用中文
      system_prompt = "你是一个AI编程助手。请始终用中文回答用户的问题。当用户询问代码相关问题时，请用中文解释，并在需要时提供代码示例。",
      mappings = {
        -- Use tab for completion
        complete = {
          detail = "Use @<Tab> or /<Tab> for options.",
          insert = "<Tab>",
        },
        -- Close the chat
        close = {
          normal = "q",
          insert = "<C-c>",
        },
        -- Reset the chat buffer
        reset = {
          normal = "<C-x>",
          insert = "<C-x>",
        },
        -- Submit the prompt to Copilot
        submit_prompt = {
          normal = "<CR>",
          insert = "<C-CR>",
        },
        -- Accept the diff
        accept_diff = {
          normal = "<C-y>",
          insert = "<C-y>",
        },
        -- Show help
        show_help = {
          normal = "g?",
        },
      },
    },
    config = function(_, opts)
      local chat = require "CopilotChat"
      local user = vim.env.USER or "User"
      user = user:sub(1, 1):upper() .. user:sub(2)
      opts.question_header = "  " .. user .. " "
      opts.answer_header = "  Copilot "

      chat.setup(opts)

      local select = require "CopilotChat.select"
      vim.api.nvim_create_user_command(
        "CopilotChatVisual",
        function(args) chat.ask(args.args, { selection = select.visual }) end,
        { nargs = "*", range = true }
      )

      -- Inline chat with Copilot
      vim.api.nvim_create_user_command(
        "CopilotChatInline",
        function(args)
          chat.ask(args.args, {
            selection = select.visual,
            window = {
              layout = "float",
              relative = "cursor",
              width = 1,
              height = 0.4,
              row = 1,
            },
          })
        end,
        { nargs = "*", range = true }
      )

      -- Restore CopilotChatBuffer
      vim.api.nvim_create_user_command(
        "CopilotChatBuffer",
        function(args) chat.ask(args.args, { selection = select.buffer }) end,
        { nargs = "*", range = true }
      )

      -- Custom buffer for CopilotChat
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-*",
        callback = function()
          vim.opt_local.relativenumber = true
          vim.opt_local.number = true

          -- Get current filetype and set it to markdown if the current filetype is copilot-chat
          local ft = vim.bo.filetype
          if ft == "copilot-chat" then vim.bo.filetype = "markdown" end
        end,
      })
    end,
    event = "VeryLazy",
    keys = {
      -- Show prompts actions
      {
        "<leader>ccp",
        function()
          require("CopilotChat").select_prompt {
            context = {
              "buffers",
            },
          }
        end,
        desc = "CopilotChat - Prompt actions",
      },
      {
        "<leader>ccp",
        function() require("CopilotChat").select_prompt() end,
        mode = "x",
        desc = "CopilotChat - Prompt actions",
      },
      -- Code related commands
      { "<leader>cce", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
      { "<leader>cct", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
      { "<leader>ccr", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
      { "<leader>ccR", "<cmd>CopilotChatRefactor<cr>", desc = "CopilotChat - Refactor code" },
      { "<leader>ccn", "<cmd>CopilotChatBetterNamings<cr>", desc = "CopilotChat - Better Naming" },
      -- Chat with Copilot in visual mode
      {
        "<leader>ccv",
        ":CopilotChatVisual",
        mode = "x",
        desc = "CopilotChat - Open in vertical split",
      },
      {
        "<leader>ccx",
        ":CopilotChatInline",
        mode = "x",
        desc = "CopilotChat - Inline chat",
      },
      -- Custom input for CopilotChat
      {
        "<leader>cci",
        function()
          local input = vim.fn.input "询问 Copilot: "
          if input ~= "" then vim.cmd("CopilotChat " .. input) end
        end,
        desc = "CopilotChat - Ask input",
      },
      -- Generate commit message based on the git diff
      {
        "<leader>ccm",
        "<cmd>CopilotChatCommit<cr>",
        desc = "CopilotChat - Generate commit message for all changes",
      },
      -- Quick chat with Copilot
      {
        "<leader>ccq",
        function()
          local input = vim.fn.input "快速聊天: "
          if input ~= "" then vim.cmd("CopilotChatBuffer " .. input) end
        end,
        desc = "CopilotChat - Quick chat",
      },
      -- Fix the issue with diagnostic
      { "<leader>ccf", "<cmd>CopilotChatFixError<cr>", desc = "CopilotChat - Fix Diagnostic" },
      -- Clear buffer and chat history
      { "<leader>ccl", "<cmd>CopilotChatReset<cr>", desc = "CopilotChat - Clear buffer and chat history" },
      -- Toggle Copilot Chat Vsplit
      { "<leader>ccT", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChat - Toggle" },
      -- Copilot Chat Models
      { "<leader>cc?", "<cmd>CopilotChatModels<cr>", desc = "CopilotChat - Select Models" },
      -- Copilot Chat Agents
      { "<leader>cca", "<cmd>CopilotChatAgents<cr>", desc = "CopilotChat - Select Agents" },
    },
  },
}
