-- 简单的 Go 过滤器测试
local M = {}

-- 基础功能测试
function M.basic_test()
  print("🧪 开始基础功能测试...")
  
  -- 1. 测试模块加载
  local success, filter_manager = pcall(require, "go_filter_manager")
  if not success then
    print("❌ 模块加载失败:", filter_manager)
    return false
  end
  print("✅ 模块加载成功")
  
  -- 2. 测试过滤状态
  local status = filter_manager.get_status_text()
  print("📊 当前状态:", status)
  
  -- 3. 测试文件过滤
  local test_files = {
    "main.go",
    "main_test.go",
    "/path/to/main_test.go",
    "vendor/pkg/lib.go"
  }
  
  print("🔍 文件过滤测试:")
  for _, file in ipairs(test_files) do
    local should_filter = filter_manager.should_filter_file(file)
    local status_icon = should_filter and "❌" or "✅"
    print(string.format("  %s %s", status_icon, file))
  end
  
  return true
end

-- 安全的引用测试
function M.safe_references_test()
  print("\n🔍 安全引用测试...")
  
  -- 检查当前位置是否有 LSP 客户端
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    print("⚠️  当前缓冲区没有 LSP 客户端")
    return false
  end
  
  print("✅ LSP 客户端已连接:", clients[1].name)
  
  -- 获取当前位置参数
  local params = vim.lsp.util.make_position_params()
  print("📍 当前位置:", params.position.line, params.position.character)
  
  -- 测试原始 LSP 引用
  print("🔍 测试原始 LSP 引用...")
  vim.lsp.buf_request(0, 'textDocument/references', params, function(err, result, ctx, config)
    if err then
      print("❌ LSP 引用查找错误:", err.message)
      return
    end
    
    if not result or #result == 0 then
      print("ℹ️  没有找到引用")
      return
    end
    
    print("✅ 原始引用数量:", #result)
    for i, ref in ipairs(result) do
      local filepath = vim.uri_to_fname(ref.uri)
      print(string.format("  %d. %s", i, filepath))
    end
    
    -- 现在测试过滤功能
    print("\n🧪 测试过滤功能...")
    local filter_manager = require("go_filter_manager")
    local filtered = filter_manager.filter_lsp_references(result)
    print("✅ 过滤后引用数量:", #filtered)
    
    for i, ref in ipairs(filtered) do
      local filepath = vim.uri_to_fname(ref.uri)
      print(string.format("  %d. %s", i, filepath))
    end
  end)
  
  return true
end

-- 完整测试
function M.run_all_tests()
  print("🚀 开始完整测试套件...\n")
  
  if not M.basic_test() then
    print("\n❌ 基础测试失败，停止测试")
    return
  end
  
  M.safe_references_test()
  
  print("\n✅ 测试完成！")
  print("\n💡 使用方法:")
  print("  - 将光标置于函数名上")
  print("  - 按 gr 查看过滤后的引用")
  print("  - 按 gR 查看所有引用（无过滤）")
  print("  - 按 <Leader>gt 切换测试文件显示")
end

return M