-- return {
--   "rest-nvim/rest.nvim",
--   dependencies = {
--     "nvim-treesitter/nvim-treesitter",
--     opts = function(_, opts)
--       opts.ensure_installed = opts.ensure_installed or {}
--       table.insert(opts.ensure_installed, "http")
--     end,
--   },
-- }

return {
  "rest-nvim/rest.nvim",
  ft = "http",
  config = function()
    require("rest-nvim").setup {
      -- 结果窗口配置
      result = {
        -- 在新窗口中显示结果
        show_url = true,
        -- 显示 HTTP 信息
        show_http_info = true,
        -- 显示响应头
        show_headers = true,
        -- 显示统计信息
        show_curl_command = true,
        -- 格式化 JSON 响应
        formatters = {
          json = "jq",
          html = {
            cmd = "tidy",
            args = {
              "-i",
              "-q",
              "--tidy-mark",
              "no",
              "--show-body-only",
              "auto",
              "--show-errors",
              "0",
              "--show-warnings",
              "0",
            },
          },
        },
      },
      -- 高亮配置
      highlight = {
        enabled = true,
        timeout = 150,
      },
      -- 结果行为
      result_split_horizontal = false,
      result_split_in_place = false,
      skip_ssl_verification = false,
      encode_url = true,
      jump_to_request = false,
      env_file = ".env",
      custom_dynamic_variables = {},
      yank_dry_run = true,
    }

    -- 基本快捷键映射
    local function map(mode, lhs, rhs, opts)
      local options = { noremap = true, silent = true }
      if opts then options = vim.tbl_extend("force", options, opts) end
      vim.keymap.set(mode, lhs, rhs, options)
    end

    -- 只在 http 文件类型中设置快捷键
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "http",
      callback = function()
        local opts = { buffer = 0 }

        -- 核心功能快捷键
        map(
          "n",
          "<leader>rr",
          "<cmd>Rest run<cr>",
          vim.tbl_extend("force", opts, { desc = "Rest: Run request under cursor" })
        )
        map(
          "n",
          "<leader>rl",
          "<cmd>Rest run last<cr>",
          vim.tbl_extend("force", opts, { desc = "Rest: Run last request" })
        )
        map("n", "<leader>rv", "<cmd>Rest run<cr>", vim.tbl_extend("force", opts, { desc = "Rest: Preview request" }))

        -- 结果窗口管理
        map("n", "<leader>rs", "<cmd>Rest show<cr>", vim.tbl_extend("force", opts, { desc = "Rest: Show result" }))
        map("n", "<leader>rh", "<cmd>Rest hide<cr>", vim.tbl_extend("force", opts, { desc = "Rest: Hide result" }))
        map(
          "n",
          "<leader>rt",
          "<cmd>Rest toggle<cr>",
          vim.tbl_extend("force", opts, { desc = "Rest: Toggle result window" })
        )

        -- 环境变量和配置
        map(
          "n",
          "<leader>re",
          "<cmd>Rest env show<cr>",
          vim.tbl_extend("force", opts, { desc = "Rest: Show environment" })
        )
        map(
          "n",
          "<leader>rE",
          "<cmd>Rest env select<cr>",
          vim.tbl_extend("force", opts, { desc = "Rest: Select environment" })
        )

        -- 日志和调试
        map("n", "<leader>rL", "<cmd>Rest logs<cr>", vim.tbl_extend("force", opts, { desc = "Rest: Show logs" }))
        map(
          "n",
          "<leader>rc",
          "<cmd>Rest curl<cr>",
          vim.tbl_extend("force", opts, { desc = "Rest: Show curl command" })
        )

        -- 导航功能
        map(
          "n",
          "<leader>rn",
          "<cmd>Rest next<cr>",
          vim.tbl_extend("force", opts, { desc = "Rest: Go to next request" })
        )
        map(
          "n",
          "<leader>rp",
          "<cmd>Rest prev<cr>",
          vim.tbl_extend("force", opts, { desc = "Rest: Go to previous request" })
        )

        -- 额外的便捷快捷键
        map(
          "n",
          "<leader>rq",
          "<cmd>Rest quit<cr>",
          vim.tbl_extend("force", opts, { desc = "Rest: Quit and close result" })
        )
        map(
          "n",
          "<leader>rR",
          "<cmd>Rest rerun<cr>",
          vim.tbl_extend("force", opts, { desc = "Rest: Rerun current request" })
        )

        -- 快速跳转到常用请求（基于行号或标记）
        map("n", "<leader>r1", "1G/###<cr>", vim.tbl_extend("force", opts, { desc = "Rest: Go to 1st request" }))
        map("n", "<leader>r2", "1G/###<cr>n", vim.tbl_extend("force", opts, { desc = "Rest: Go to 2nd request" }))
        map("n", "<leader>r3", "1G/###<cr>nn", vim.tbl_extend("force", opts, { desc = "Rest: Go to 3rd request" }))

        -- 文本对象和选择
        map(
          "n",
          "<leader>ra",
          "?^###<cr>V/^###<cr>k",
          vim.tbl_extend("force", opts, { desc = "Rest: Select current request" })
        )
        map(
          "v",
          "<leader>rr",
          "<cmd>Rest run<cr>",
          vim.tbl_extend("force", opts, { desc = "Rest: Run selected request" })
        )
      end,
    })

    -- 全局快捷键（不限于 http 文件）
    map("n", "<leader>ro", "<cmd>e api-test.http<cr>", { desc = "Rest: Open API test file" })
    map("n", "<leader>rO", "<cmd>vs api-test.http<cr>", { desc = "Rest: Open API test file in split" })

    -- 创建新的 HTTP 请求文件
    map("n", "<leader>rN", function()
      local filename = vim.fn.input("HTTP file name: ", "api-test.http")
      if filename ~= "" then
        vim.cmd("e " .. filename)
        vim.bo.filetype = "http"
      end
    end, { desc = "Rest: Create new HTTP file" })
  end,
}

-- 可选：Which-key 集成配置
-- 如果你使用 which-key.nvim，可以添加以下配置：
--[[
local wk = require("which-key")
wk.register({
  ["<leader>r"] = {
    name = "Rest/HTTP",
    r = "Run request",
    l = "Run last",
    v = "Preview",
    s = "Show result",
    h = "Hide result",
    t = "Toggle result",
    e = "Show env",
    E = "Select env",
    L = "Show logs",
    c = "Show curl",
    n = "Next request",
    p = "Previous request",
    q = "Quit",
    R = "Rerun",
    o = "Open API file",
    O = "Open in split",
    N = "New HTTP file",
    a = "Select request",
    ["1"] = "Go to 1st request",
    ["2"] = "Go to 2nd request",
    ["3"] = "Go to 3rd request",
  }
}, { mode = "n" })
--]]
