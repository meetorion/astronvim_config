return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false, -- 永远不要将此值设置为 "*"！永远不要！
  opts = {
    provider = "openai",
    openai = {
      endpoint = "https://openrouter.ai/api/v1",
      api_key = os.getenv "OPENAI_API_KEY", -- 使用 OPENAI_API_KEY 环境变量
      model = "anthropic/claude-3-5-sonnet", -- 更新为正确的模型名称
      timeout = 60000, -- 增加超时时间到60秒
      temperature = 0.1,
      max_tokens = 4096,
      -- 添加 OpenRouter 所需的头信息
      http_headers = {
        ["HTTP-Referer"] = "https://neovim.io",
        ["X-Title"] = "Neovim Avante",
      },
    },
    -- 自定义快捷键
    keymaps = {
      -- 全局快捷键
      global = {
        ["<leader>aa"] = "avante.toggle", -- 切换 Avante 面板
        ["<leader>ac"] = "avante.chat", -- 开始新的聊天
        ["<leader>af"] = "avante.file_chat", -- 基于当前文件的聊天
      },
      -- 在 Avante 缓冲区内的快捷键
      buffer = {
        ["<C-s>"] = "avante.save_chat", -- 保存聊天
        ["<C-r>"] = "avante.retry_last", -- 重试最后一个请求
      },
    },
    -- 自定义 UI 设置
    ui = {
      width = 0.8, -- 面板宽度（相对于窗口宽度的比例）
      height = 0.8, -- 面板高度（相对于窗口高度的比例）
      border = "rounded", -- 边框样式: "none", "single", "double", "rounded", "solid", "shadow"
      winblend = 0, -- 透明度 (0-100)
    },
    -- 文件聊天设置
    file_chat = {
      include_line_numbers = true, -- 在代码片段中包含行号
      include_file_name = true, -- 在代码片段中包含文件名
    },
    -- 保存聊天设置
    save = {
      directory = vim.fn.stdpath("data") .. "/avante/chats", -- 保存聊天的目录
      format = "markdown", -- 保存格式: "markdown" 或 "json"
    },
  },
  -- 如果您想从源代码构建，请执行 `make BUILD_FROM_SOURCE=true`
  build = "make",
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- 对于 Windows
  config = function()
    -- 设置 Avante 命令
    vim.api.nvim_create_user_command("AvanteChat", function()
      require("avante").chat()
    end, {})
    
    vim.api.nvim_create_user_command("AvanteFileChat", function()
      require("avante").file_chat()
    end, {})
    
    -- 设置自定义提示模板
    require("avante").setup_prompt_templates({
      code_review = [[
请帮我审查以下代码，指出潜在的问题、改进点和最佳实践：

```{{filetype}}
{{selection}}
```
      ]],
      explain_code = [[
请详细解释以下代码的功能和工作原理：

```{{filetype}}
{{selection}}
```
      ]],
      optimize = [[
请优化以下代码，提高其性能、可读性和可维护性：

```{{filetype}}
{{selection}}
```
      ]],
    })
  end,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- 以下依赖项是可选的，
    "echasnovski/mini.pick", -- 用于文件选择器提供者 mini.pick
    "nvim-telescope/telescope.nvim", -- 用于文件选择器提供者 telescope
    "hrsh7th/nvim-cmp", -- avante 命令和提及的自动完成
    "ibhagwan/fzf-lua", -- 用于文件选择器提供者 fzf
    "nvim-tree/nvim-web-devicons", -- 或 echasnovski/mini.icons
    "zbirenbaum/copilot.lua", -- 用于 providers='copilot'
    {
      -- 支持图像粘贴
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- 推荐设置
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- Windows 用户必需
          use_absolute_path = true,
        },
      },
    },
    {
      -- 如果您有 lazy=true，请确保正确设置
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
