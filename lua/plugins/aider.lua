return {
  "joshuavial/aider.nvim",
  opts = {
    -- your configuration comes here
    -- if you don't want to use the default settings
    auto_manage_context = true, -- automatically manage buffer context
    default_bindings = true, -- use default <leader>A keybindings
    debug = false, -- enable debug logging
    -- 添加 aider.nvim 插件介绍和与 avante.nvim 的区别说明
    -- aider.nvim: 基于 Aider CLI 工具的 Neovim 集成，专注于代码协作
    -- avante.nvim: 原生 Neovim 插件，功能更丰富，支持多种 AI 模型和 MCP
  },
}
