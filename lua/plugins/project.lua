return {
  {
    "coffebar/neovim-project",
    opts = {
      projects = { -- 定义项目根目录
        "~/git/*",
        "~/.config/nvim",
        -- "~/.config/*",
      },
      -- 可选：自定义项目检测标记文件
      detection = {
        -- 这些文件或目录存在时会被视为项目根目录
        files = {
          ".git",
          ".svn",
          ".hg",
          "package.json",
          "Cargo.toml",
        },
      },
      -- 项目选择器配置
      picker = {
        type = "telescope", -- 或者使用 "fzf-lua"
      },
      -- 会话管理配置
      session = {
        enabled = true,
        -- 可选：自定义会话目录
        dir = vim.fn.stdpath "data" .. "/project_nvim/sessions/",
        -- 自动保存会话
        autosave = {
          enabled = true,
          interval = 60, -- 每60秒自动保存一次
        },
      },
    },
    init = function()
      -- 启用在会话中保存插件状态
      vim.opt.sessionoptions:append "globals" -- 保存以大写字母开头且至少包含一个小写字母的全局变量
    end,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      -- 可选的项目选择器
      { "nvim-telescope/telescope.nvim", tag = "0.1.4" },
      -- 可选的项目选择器
      { "ibhagwan/fzf-lua" },
      -- 会话管理
      { "Shatur/neovim-session-manager" },
    },
    lazy = false,
    priority = 100,
  },
}
