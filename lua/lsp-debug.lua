-- LSP 调试助手
-- 在 Neovim 中运行 :lua require('lsp-debug').check() 来诊断 LSP 问题

local M = {}

function M.check()
  print("=== LSP 调试信息 ===")
  
  -- 检查当前缓冲区的 LSP 客户端
  local clients = vim.lsp.buf_get_clients()
  print("当前缓冲区的 LSP 客户端数量:", #clients)
  
  for i, client in ipairs(clients) do
    print(string.format("客户端 %d: %s (ID: %d)", i, client.name, client.id))
    print("  - 根目录:", client.config.root_dir)
    print("  - 状态:", client.is_stopped() and "已停止" or "运行中")
    
    -- 检查服务器能力
    if client.server_capabilities then
      print("  - 支持跳转到定义:", client.server_capabilities.definitionProvider or false)
      print("  - 支持跳转到实现:", client.server_capabilities.implementationProvider or false)
      print("  - 支持跳转到引用:", client.server_capabilities.referencesProvider or false)
      print("  - 支持悬停:", client.server_capabilities.hoverProvider or false)
    end
  end
  
  -- 检查键绑定
  print("\n=== 键绑定检查 ===")
  local buf = vim.api.nvim_get_current_buf()
  local keymaps = vim.api.nvim_buf_get_keymap(buf, 'n')
  
  local lsp_keys = {'gd', 'gD', 'gi', 'gr', 'K'}
  for _, key in ipairs(lsp_keys) do
    local found = false
    for _, keymap in ipairs(keymaps) do
      if keymap.lhs == key then
        print(string.format("  %s -> %s", key, keymap.rhs or "LSP 函数"))
        found = true
        break
      end
    end
    if not found then
      print(string.format("  %s -> 未设置", key))
    end
  end
  
  -- 检查项目根目录
  print("\n=== 项目信息 ===")
  local cwd = vim.fn.getcwd()
  print("当前工作目录:", cwd)
  
  -- 检查 Java 项目文件
  local java_files = {'pom.xml', 'build.gradle', 'build.gradle.kts', '.project'}
  for _, file in ipairs(java_files) do
    local path = cwd .. '/' .. file
    if vim.fn.filereadable(path) == 1 then
      print("找到项目文件:", file)
    end
  end
  
  -- 检查 Java 版本
  print("\n=== Java 环境 ===")
  local java_version = vim.fn.system('java -version 2>&1 | head -1')
  print("Java 版本:", vim.trim(java_version))
  
  local java_home = vim.fn.getenv('JAVA_HOME')
  if java_home then
    print("JAVA_HOME:", java_home)
  else
    print("JAVA_HOME: 未设置")
  end
  
  print("\n=== 调试完成 ===")
  print("如果 gd 不工作，请尝试:")
  print("1. 重新启动 LSP: :LspRestart")
  print("2. 重新载入文件: :e")
  print("3. 检查 LSP 日志: :LspLog")
end

function M.restart_java_lsp()
  print("重启 Java LSP...")
  for _, client in ipairs(vim.lsp.buf_get_clients()) do
    if client.name == "jdtls" then
      vim.lsp.stop_client(client.id)
      print("已停止 JDTLS 客户端")
    end
  end
  
  -- 等待一秒后重新触发 LSP
  vim.defer_fn(function()
    vim.cmd('edit')
    print("LSP 重启完成，请稍等片刻让服务器初始化")
  end, 1000)
end

function M.test_goto_definition()
  print("测试跳转到定义...")
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, 'textDocument/definition', params, function(err, result, ctx, config)
    if err then
      print("错误:", err.message)
    elseif result and #result > 0 then
      print("找到定义:", #result, "个位置")
      for i, location in ipairs(result) do
        print(string.format("  位置 %d: %s:%d:%d", i, location.uri, location.range.start.line + 1, location.range.start.character + 1))
      end
    else
      print("未找到定义")
    end
  end)
end

return M