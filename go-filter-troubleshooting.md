# Go 过滤器故障排除指南

如果您的 `gr` 命令仍然显示 `*_test.go` 文件的引用，请按照以下步骤进行诊断和修复：

## 🚀 快速修复步骤

### 1. 重启 Neovim
```bash
# 完全退出 Neovim，然后重新启动
:qa!
# 重新启动
nvim
```

### 2. 运行测试套件
在 Neovim 中，打开任意 Go 文件，然后运行：
```
<Leader>gT
```
这会运行完整的测试套件，验证所有功能是否正常。

### 3. 运行完整诊断
```
<Leader>gd
```
这会显示完整的诊断信息，包括：
- 模块加载状态
- 键映射检查
- 过滤模式测试
- LSP 集成测试

### 4. 手动测试过滤功能
```
<Leader>gr
```
这会手动触发过滤引用查找，并显示详细信息。

### 5. 开启调试模式
```
<Leader>gD
```
开启调试模式后，每次使用 `gr` 都会显示详细的过滤过程。

## 🔍 详细诊断步骤

### 检查 1: 模块加载
在 Neovim 命令行中运行：
```lua
:lua print(require("go_filter_manager").get_status_text())
```

**期望输出**: `测试:❌ 依赖:❌`
**如果报错**: 说明模块加载失败，检查文件路径

### 检查 2: 键映射验证
```lua
:lua require("debug_go_filter").check_key_mappings()
```

**期望看到**: `gr` 映射指向过滤函数
**如果没有**: 说明键映射被覆盖

### 检查 3: 过滤逻辑测试
```lua
:lua require("debug_go_filter").test_filter_patterns()
```

**期望看到**: `*_test.go` 文件被标记为 "❌ 过滤"

### 检查 4: 实际文件测试
在任意 Go 文件中，将光标置于一个函数名上，然后：
```
<Leader>gD  # 开启调试模式
gr          # 查找引用
```

观察输出中的 `[DEBUG]` 信息。

## 🛠 常见问题和解决方案

### 问题 1: "go_filter_manager 模块加载失败"
**原因**: 文件路径错误或语法错误
**解决**: 
```lua
:lua package.loaded["go_filter_manager"] = nil  -- 清除缓存
:lua require("go_filter_manager")               -- 重新加载
```

### 问题 2: "gr 映射未找到"
**原因**: AstroNvim 的默认配置覆盖了我们的设置
**解决**: 强制重新设置映射
```lua
:lua require("go_lsp_override").setup()
```

### 问题 3: "textDocument/references is a nil value"
**原因**: LSP handler 调用方式错误（已修复）
**解决**: 错误会自动回退到默认 LSP 引用查找
```lua
:lua require("debug_go_filter").reload_config()  -- 重新加载修复后的配置
```

### 问题 4: "过滤不生效"
**原因**: 文件路径模式不匹配
**解决**: 检查实际文件路径格式
```lua
:lua print(vim.uri_to_fname("file:///your/test/file_test.go"))
```

### 问题 5: "LSP 引用为空"
**原因**: LSP 服务器未正确启动
**解决**: 
```
:LspInfo  # 检查 LSP 状态
:LspRestart  # 重启 LSP
```

## 🔧 手动强制修复

如果自动配置不生效，可以手动设置：

### 1. 手动设置键映射（临时）
```lua
:lua vim.keymap.set('n', 'gr', function() require("go_filter_manager").filtered_references() end, { desc = "Filtered references" })
```

### 2. 手动切换过滤状态
```lua
:lua require("go_filter_manager").state.include_tests = false
```

### 3. 强制重新加载所有配置
```lua
:lua require("debug_go_filter").reload_config()
```

## 📊 验证修复效果

### 测试场景
1. 在一个 Go 项目中创建测试文件：
   - `main.go` - 定义一个函数 `func Hello() {}`
   - `main_test.go` - 调用 `Hello()` 函数

2. 在 `main.go` 中将光标置于 `Hello` 函数名上

3. 按 `gr`

**期望结果**: 只显示 `main.go` 中的引用，不显示 `main_test.go` 中的引用

**如果仍显示测试文件引用**: 
1. 开启调试模式: `<Leader>gD`
2. 再次按 `gr`
3. 查看调试输出，确定过滤是否执行

## 🎯 快捷键参考

| 快捷键 | 功能 | 用途 |
|--------|------|------|
| `<Leader>gd` | 完整诊断 | 诊断所有配置 |
| `<Leader>gr` | 手动过滤引用 | 绕过可能的映射问题 |
| `<Leader>gD` | 切换调试模式 | 查看详细过滤过程 |
| `<Leader>gR` | 重新加载配置 | 刷新配置 |
| `<Leader>gt` | 切换测试文件显示 | 临时包含测试文件 |
| `<Leader>gs` | 显示当前状态 | 查看过滤设置 |
| `gR` | 原始引用查找 | 无过滤的引用查找 |

## 🆘 最后手段

如果所有方法都不奏效，请：

1. **备份并重置配置**:
   ```bash
   cd ~/.config/nvim
   git stash  # 如果使用 git
   # 重新应用配置
   ```

2. **检查 AstroNvim 版本兼容性**:
   ```
   :AstroVersion
   ```

3. **查看错误日志**:
   ```
   :messages
   ```

4. **创建最小重现配置** 进行测试

## 💡 提示

- 确保您使用的是支持 LSP 的 Go 语言服务器（如 `gopls`）
- 某些 Go 项目可能需要 `go mod tidy` 来正确设置 LSP
- 如果在大型项目中，LSP 初始化可能需要一些时间

记住，调试信息是您的朋友！开启调试模式能让您看到整个过滤过程。