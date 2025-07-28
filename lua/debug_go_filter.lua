-- Go过滤器调试工具
local M = {}

-- 检查模块加载状态
function M.check_module_loading()
  print("=== Go Filter Manager 模块检查 ===")
  
  local success, filter_manager = pcall(require, "go_filter_manager")
  if success then
    print("✅ go_filter_manager 模块加载成功")
    print("📊 当前状态:", filter_manager.get_status_text())
    print("🔧 包含测试文件:", filter_manager.state.include_tests)
    print("🔧 包含vendor:", filter_manager.state.include_vendor)
  else
    print("❌ go_filter_manager 模块加载失败:", filter_manager)
    return false
  end
  
  return true
end

-- 检查键映射
function M.check_key_mappings()
  print("\n=== 键映射检查 ===")
  
  -- 检查 gr 映射
  local gr_mapping = vim.api.nvim_get_keymap('n')
  for _, mapping in ipairs(gr_mapping) do
    if mapping.lhs == 'gr' then
      print("🔍 发现 gr 映射:")
      print("  - lhs:", mapping.lhs)
      print("  - rhs:", mapping.rhs or "无")
      print("  - callback:", mapping.callback and "存在" or "无")
      print("  - desc:", mapping.desc or "无描述")
      break
    end
  end
  
  -- 检查其他相关映射
  local keys_to_check = {"<Leader>gt", "<Leader>gv", "<Leader>gs"}
  for _, key in ipairs(keys_to_check) do
    local found = false
    for _, mapping in ipairs(gr_mapping) do
      if mapping.lhs == key then
        print("🔍 发现", key, "映射:", mapping.desc or "无描述")
        found = true
        break
      end
    end
    if not found then
      print("⚠️ 未找到", key, "映射")
    end
  end
end

-- 测试过滤模式
function M.test_filter_patterns()
  print("\n=== 过滤模式测试 ===")
  
  local success, filter_manager = pcall(require, "go_filter_manager")
  if not success then
    print("❌ 无法加载 filter_manager")
    return
  end
  
  local test_files = {
    "/path/to/main.go",
    "/path/to/main_test.go", 
    "/path/to/test_helper.go",
    "/path/to/test/helper.go",
    "/path/to/vendor/github.com/pkg/pkg.go",
    "/path/to/internal/service.go",
    "/path/to/go.mod",
  }
  
  print("🧪 测试文件过滤:")
  for _, file in ipairs(test_files) do
    local should_filter = filter_manager.should_filter_file(file)
    local status = should_filter and "❌ 过滤" or "✅ 包含"
    print(string.format("  %s: %s", file, status))
  end
end

-- 测试实际的 LSP 引用过滤
function M.test_lsp_filtering()
  print("\n=== LSP 引用过滤测试 ===")
  
  local success, filter_manager = pcall(require, "go_filter_manager")
  if not success then
    print("❌ 无法加载 filter_manager")
    return
  end
  
  -- 模拟 LSP 引用结果
  local mock_references = {
    {
      uri = "file:///path/to/main.go",
      range = { start = { line = 10, character = 5 } }
    },
    {
      uri = "file:///path/to/main_test.go", 
      range = { start = { line = 20, character = 10 } }
    },
    {
      uri = "file:///path/to/vendor/pkg/pkg.go",
      range = { start = { line = 30, character = 15 } }
    }
  }
  
  print("🔍 原始引用数量:", #mock_references)
  local filtered = filter_manager.filter_lsp_references(mock_references)
  print("🔍 过滤后数量:", #filtered)
  
  print("📋 过滤结果:")
  for i, ref in ipairs(filtered) do
    local filepath = vim.uri_to_fname(ref.uri)
    print(string.format("  %d. %s", i, filepath))
  end
end

-- 手动触发过滤引用查找
function M.manual_filtered_references()
  print("\n=== 手动触发过滤引用查找 ===")
  
  local success, filter_manager = pcall(require, "go_filter_manager")
  if not success then
    print("❌ 无法加载 filter_manager，使用默认 LSP 引用")
    vim.lsp.buf.references()
    return
  end
  
  print("🔍 使用过滤管理器查找引用...")
  
  -- 包装错误处理
  local ok, err = pcall(filter_manager.filtered_references)
  if not ok then
    print("❌ 过滤引用查找出错:", err)
    print("🔄 回退到默认 LSP 引用查找...")
    vim.lsp.buf.references()
  end
end

-- 综合诊断
function M.full_diagnosis()
  print("🔧 开始 Go Filter 完整诊断...\n")
  
  if not M.check_module_loading() then
    print("\n❌ 诊断中止：模块加载失败")
    return
  end
  
  M.check_key_mappings()
  M.test_filter_patterns()
  M.test_lsp_filtering()
  
  print("\n✅ 诊断完成！")
  print("💡 如果问题仍存在，请检查:")
  print("   1. 是否重启了 Neovim")
  print("   2. astrolsp.lua 配置是否正确加载")
  print("   3. 尝试手动运行 :lua require('debug_go_filter').manual_filtered_references()")
end

-- 强制重新加载配置
function M.reload_config()
  print("🔄 重新加载 Go Filter 配置...")
  
  -- 清除模块缓存
  package.loaded["go_filter_manager"] = nil
  
  -- 重新加载模块
  local success, filter_manager = pcall(require, "go_filter_manager")
  if success then
    print("✅ go_filter_manager 重新加载成功")
    print("📊 当前状态:", filter_manager.get_status_text())
  else
    print("❌ 重新加载失败:", filter_manager)
  end
end

return M