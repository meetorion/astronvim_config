# 修复 Avante.nvim spinner_char 错误

## 错误原因

这个错误是由于 Avante.nvim 插件中的 spinner_char 变量为 nil 导致的字符串拼接失败。通常是因为：

1. 插件版本不兼容
2. 插件构建不完整
3. 配置冲突

## 解决方案

### 方法 1：更新和重新构建插件（推荐）

在 Neovim 中执行以下命令：

```lua
:Lazy update avante.nvim
:Lazy rebuild avante.nvim
```

或者在终端中：

```bash
cd ~/.local/share/nvim/lazy/avante.nvim
make clean
make
```

### 方法 2：重置插件

完全删除并重新安装插件：

```bash
rm -rf ~/.local/share/nvim/lazy/avante.nvim
```

然后重启 Neovim，Lazy.nvim 会自动重新安装。

### 方法 3：使用配置修复

我已经在配置中添加了以下修复：

1. **安全的 spinner 配置**：
```lua
ui = {
  spinner = {
    enabled = true,
    frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
    interval = 80,
  },
},
```

2. **错误处理包装**：
- 添加了 `avante_fix.lua` 模块来捕获和处理 spinner_char 错误
- 在配置中添加了安全的初始化代码

### 方法 4：临时禁用 Avante

如果问题持续存在，可以临时禁用 Avante：

在 `lua/plugins/avante.lua` 中添加：

```lua
return {
  "yetone/avante.nvim",
  enabled = false, -- 临时禁用
  -- ... 其他配置
}
```

## 验证修复

重启 Neovim 后，尝试：

1. 运行 `:checkhealth avante` 检查插件状态
2. 使用 `<leader>aa` 打开 Avante 侧边栏
3. 检查是否还有错误信息

## 如果问题仍然存在

1. 检查 Neovim 版本：`nvim --version`（需要 0.10+）
2. 检查依赖是否正确安装：`:Lazy check`
3. 查看详细错误日志：`:messages`
4. 考虑切换到稳定分支或特定版本

## 预防措施

为了避免类似问题，建议：

1. 定期更新插件但测试后再使用
2. 使用版本锁定避免意外更新
3. 保持 Neovim 和依赖插件的兼容性