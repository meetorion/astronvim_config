# Go 开发智能过滤切换功能

为您的 Neovim Go 开发环境添加了智能过滤功能，可以快速切换是否显示测试文件和 vendor 目录。

## 🚀 功能特性

### 默认行为
- **`gr` (引用查找)**: 默认**排除**测试文件中的引用
- **`<Leader>ff` (文件搜索)**: 默认**排除** vendor 目录和测试文件
- **智能过滤**: 自动识别 Go 测试文件模式 (`*_test.go`, `test_*.go` 等)

### 快捷键一览

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `<Leader>gt` | 切换测试文件显示 | 影响 `gr` 和 `<Leader>ff` |
| `<Leader>gv` | 切换 vendor 目录显示 | 影响 `<Leader>ff` |
| `<Leader>gs` | 显示当前过滤状态 | 查看当前过滤配置 |
| `<Leader>ff` | 智能文件搜索 | 根据当前过滤状态搜索 |
| `<Leader>fF` | 搜索所有文件 | 无过滤搜索 |
| `<Leader>fg` | 智能内容搜索 | 根据当前过滤状态搜索 |
| `<Leader>fG` | 搜索所有内容 | 无过滤搜索 |
| `gr` | 智能引用查找 | 根据当前过滤状态显示引用 |

## 📋 使用场景

### 场景1: 日常开发（默认）
```
状态: 测试:❌ 依赖:❌
- gr: 只显示业务代码中的引用
- ff: 只搜索业务代码文件
```

### 场景2: 调试测试代码
```bash
# 按 <Leader>gt 切换测试文件显示
状态: 测试:✅ 依赖:❌
- gr: 显示包括测试文件在内的所有引用
- ff: 搜索包括测试文件在内的所有文件
```

### 场景3: 查看依赖源码
```bash
# 按 <Leader>gv 切换 vendor 显示
状态: 测试:❌ 依赖:✅
- ff: 搜索包括 vendor 目录在内的文件
```

## 🎯 过滤模式详解

### 测试文件模式
自动识别以下 Go 测试文件：
- `*_test.go` - 标准测试文件
- `test_*.go` - 测试文件前缀
- `*/test/*` - test 目录下的文件
- `*/tests/*` - tests 目录下的文件
- `**/test/**` - 深层 test 目录
- `**/tests/**` - 深层 tests 目录

### Vendor 和依赖模式
自动排除以下目录和文件：
- `*/vendor/*` - vendor 目录
- `**/vendor/**` - 深层 vendor 目录
- `*.mod` - go.mod 文件
- `*.sum` - go.sum 文件
- `.git/` - Git 目录
- `node_modules/` - Node.js 依赖

## 💡 使用技巧

### 1. 快速状态检查
```bash
<Leader>gs  # 显示: "过滤状态: 测试:❌ 依赖:❌"
```

### 2. 临时查看所有文件
```bash
<Leader>fF  # 搜索所有文件（包括测试和vendor）
<Leader>fG  # 搜索所有内容（包括测试和vendor）
```

### 3. 智能工作流
```bash
# 开发阶段
<Leader>ff   # 快速找业务代码文件
gr           # 查看业务代码引用

# 调试测试
<Leader>gt   # 切换包含测试文件
gr           # 现在能看到测试中的引用了

# 查看依赖
<Leader>gv   # 切换包含vendor
<Leader>ff   # 现在能搜索vendor中的文件
```

## 🔧 自定义配置

### 添加自定义过滤模式
编辑 `lua/go_filter_manager.lua`：

```lua
-- 添加自定义测试模式
M.test_patterns = {
  "*_test.go",
  "test_*.go",
  "*/test/*",
  "*integration_test.go",  -- 添加集成测试
  "*benchmark_test.go",    -- 添加基准测试
}

-- 添加自定义排除模式
M.vendor_patterns = {
  "*/vendor/*",
  "*/build/*",      -- 添加构建目录
  "*/dist/*",       -- 添加分发目录
  "*.generated.go", -- 添加生成的代码
}
```

### 修改默认状态
```lua
-- 在 go_filter_manager.lua 中修改默认状态
M.state = {
  include_tests = true,   -- 默认包含测试文件
  include_vendor = false, -- 默认排除vendor
}
```

## 🚨 故障排除

### 问题1: 过滤不生效
**解决方案**: 重启 Neovim 或运行 `:lua package.loaded["go_filter_manager"] = nil`

### 问题2: 某些文件仍然显示
**检查**: 文件路径是否匹配过滤模式，可能需要调整模式

### 问题3: Telescope 搜索异常
**解决方案**: 确保安装了 `fd` 和 `ripgrep`：
```bash
# Ubuntu/Debian
sudo apt install fd-find ripgrep

# macOS
brew install fd ripgrep

# Arch Linux
sudo pacman -S fd ripgrep
```

## 📊 状态指示器

| 图标 | 含义 |
|------|------|
| ✅ | 包含该类型文件 |
| ❌ | 排除该类型文件 |
| 🔍 | 正在搜索 |
| 📍 | 引用查找结果 |
| 🔄 | 状态切换 |

## 🎉 结语

这个智能过滤系统让您在 Go 开发中能够：
- **专注业务代码** - 默认隐藏测试和依赖
- **灵活切换** - 一键包含所需文件类型  
- **可视化反馈** - 清楚了解当前过滤状态
- **无缝集成** - 完全兼容现有 AstroNvim 配置

享受更高效的 Go 开发体验！ 🚀