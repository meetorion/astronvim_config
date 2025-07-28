-- Go语言开发过滤管理器
-- 管理测试文件和vendor目录的显示/隐藏状态

local M = {}

-- 过滤状态
M.state = {
  include_tests = false,    -- 默认不包含测试文件
  include_vendor = false,   -- 默认不包含vendor目录
}

-- Go测试文件模式
M.test_patterns = {
  "*_test.go",
  "test_*.go", 
  "*/test/*",
  "*/tests/*",
  "**/test/**",
  "**/tests/**",
}

-- Vendor和其他排除模式
M.vendor_patterns = {
  "*/vendor/*",
  "**/vendor/**",
  "vendor/",
  "*.mod",
  "*.sum",
  ".git/",
  "node_modules/",
}

-- 将glob模式转换为ripgrep模式
function M.to_rg_pattern(pattern)
  return pattern:gsub("%*%*", ".*"):gsub("%*", "[^/]*")
end

-- 将glob模式转换为Lua模式
function M.to_lua_pattern(pattern)
  -- 更精确的模式转换
  local lua_pattern = pattern
    :gsub("([%.%^%$%(%)%%[%]%*%+%-%?])", "%%%1") -- 转义特殊字符
    :gsub("%%%*%%%*", ".*")  -- ** -> .*
    :gsub("%%%*", "[^/]*")   -- * -> [^/]*
    :gsub("%%%?", ".")       -- ? -> .
  return lua_pattern
end

-- 检查文件是否应该被过滤
function M.should_filter_file(filepath)
  -- 规范化文件路径（移除 file:// 前缀，转换为小写）
  local normalized_path = filepath
  if normalized_path:match("^file://") then
    normalized_path = normalized_path:sub(8) -- 移除 "file://" 前缀
  end
  normalized_path = normalized_path:lower()
  
  -- 检查测试文件
  if not M.state.include_tests then
    -- 直接检查文件名模式
    local filename = normalized_path:match("([^/]+)$") or ""
    if filename:match("_test%.go$") or filename:match("^test_.*%.go$") then
      return true
    end
    
    -- 检查路径模式
    if normalized_path:match("/tests?/") then
      return true
    end
    
    -- 使用原有的模式检查作为备选
    for _, pattern in ipairs(M.test_patterns) do
      local lua_pattern = M.to_lua_pattern(pattern:lower())
      if normalized_path:match(lua_pattern) then
        return true
      end
    end
  end
  
  -- 检查vendor目录
  if not M.state.include_vendor then
    if normalized_path:match("/vendor/") or normalized_path:match("%.mod$") or normalized_path:match("%.sum$") then
      return true
    end
    
    for _, pattern in ipairs(M.vendor_patterns) do
      local lua_pattern = M.to_lua_pattern(pattern:lower())
      if normalized_path:match(lua_pattern) then
        return true
      end
    end
  end
  
  return false
end

-- 获取ripgrep排除参数
function M.get_rg_excludes()
  local excludes = {}
  
  if not M.state.include_tests then
    for _, pattern in ipairs(M.test_patterns) do
      table.insert(excludes, "--glob=!" .. pattern)
    end
  end
  
  if not M.state.include_vendor then
    for _, pattern in ipairs(M.vendor_patterns) do
      table.insert(excludes, "--glob=!" .. pattern)
    end
  end
  
  return excludes
end

-- 获取fd排除参数
function M.get_fd_excludes()
  local excludes = {}
  
  if not M.state.include_tests then
    for _, pattern in ipairs(M.test_patterns) do
      table.insert(excludes, "--exclude")
      table.insert(excludes, pattern)
    end
  end
  
  if not M.state.include_vendor then
    for _, pattern in ipairs(M.vendor_patterns) do
      table.insert(excludes, "--exclude")
      table.insert(excludes, pattern)
    end
  end
  
  return excludes
end

-- 切换测试文件显示状态
function M.toggle_tests()
  M.state.include_tests = not M.state.include_tests
  local status = M.state.include_tests and "包含" or "排除"
  
  vim.notify(
    string.format("🔄 测试文件过滤: %s测试文件", status),
    vim.log.levels.INFO,
    { title = "Go过滤管理器" }
  )
  
  return M.state.include_tests
end

-- 切换vendor目录显示状态
function M.toggle_vendor()
  M.state.include_vendor = not M.state.include_vendor
  local status = M.state.include_vendor and "包含" or "排除"
  
  vim.notify(
    string.format("🔄 Vendor过滤: %s vendor目录", status),
    vim.log.levels.INFO,
    { title = "Go过滤管理器" }
  )
  
  return M.state.include_vendor
end

-- 获取当前状态描述
function M.get_status_text()
  local test_status = M.state.include_tests and "✅" or "❌"
  local vendor_status = M.state.include_vendor and "✅" or "❌"
  
  return string.format("测试:%s 依赖:%s", test_status, vendor_status)
end

-- 过滤LSP引用结果
function M.filter_lsp_references(references)
  if not references or #references == 0 then
    return references
  end
  
  local filtered = {}
  for _, ref in ipairs(references) do
    local uri = ref.uri or ""
    local filepath = vim.uri_to_fname(uri)
    
    if not M.should_filter_file(filepath) then
      table.insert(filtered, ref)
    end
  end
  
  return filtered
end

-- 自定义LSP引用查找
function M.filtered_references()
  -- 添加调试信息
  local debug_mode = vim.g.go_filter_debug or false
  
  if debug_mode then
    print("🔍 [DEBUG] 开始过滤引用查找...")
    print("🔍 [DEBUG] 当前过滤状态:", M.get_status_text())
  end
  
  local params = vim.lsp.util.make_position_params()
  params.context = { includeDeclaration = true }
  
  vim.lsp.buf_request(0, 'textDocument/references', params, function(err, result, ctx, config)
    if err then
      vim.notify('LSP引用查找错误: ' .. err.message, vim.log.levels.ERROR)
      return
    end
    
    if not result or vim.tbl_isempty(result) then
      vim.notify('未找到引用', vim.log.levels.INFO)
      return
    end
    
    if debug_mode then
      print("🔍 [DEBUG] 原始引用数量:", #result)
      for i, ref in ipairs(result) do
        local filepath = vim.uri_to_fname(ref.uri)
        print(string.format("🔍 [DEBUG] 原始引用 %d: %s", i, filepath))
      end
    end
    
    -- 过滤结果
    local filtered_result = M.filter_lsp_references(result)
    
    if debug_mode then
      print("🔍 [DEBUG] 过滤后引用数量:", #filtered_result)
      for i, ref in ipairs(filtered_result) do
        local filepath = vim.uri_to_fname(ref.uri)
        print(string.format("🔍 [DEBUG] 过滤后引用 %d: %s", i, filepath))
      end
    end
    
    -- 显示过滤统计
    local original_count = #result
    local filtered_count = #filtered_result
    local excluded_count = original_count - filtered_count
    
    if excluded_count > 0 then
      vim.notify(
        string.format("📍 找到 %d 个引用 (已过滤 %d 个)", filtered_count, excluded_count),
        vim.log.levels.INFO,
        { title = "Go引用查找" }
      )
    else
      vim.notify(
        string.format("📍 找到 %d 个引用", filtered_count),
        vim.log.levels.INFO,
        { title = "Go引用查找" }
      )
    end
    
    -- 使用过滤后的结果，正确显示引用列表
    if #filtered_result == 0 then
      vim.notify('过滤后未找到引用', vim.log.levels.INFO)
      return
    elseif #filtered_result == 1 then
      -- 单个引用直接跳转
      vim.lsp.util.jump_to_location(filtered_result[1], "utf-8", true)
    else
      -- 多个引用使用 quickfix 列表
      local items = vim.lsp.util.locations_to_items(filtered_result, "utf-8")
      vim.fn.setqflist({}, ' ', { title = 'LSP References (Filtered)', items = items })
      vim.api.nvim_command('copen')
    end
  end)
end

-- 开启/关闭调试模式
function M.toggle_debug()
  vim.g.go_filter_debug = not vim.g.go_filter_debug
  local status = vim.g.go_filter_debug and "开启" or "关闭"
  vim.notify(
    string.format("🐛 Go过滤器调试模式: %s", status),
    vim.log.levels.INFO,
    { title = "调试模式" }
  )
end

return M