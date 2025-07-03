# AstroNvim Template

**NOTE:** This is for AstroNvim v4+

A template for getting started with [AstroNvim](https://github.com/AstroNvim/AstroNvim)

## ✨ 新增功能

### AI 编程助手集成

本配置集成了多个强大的 AI 编程助手，提供全方位的代码辅助功能：

#### 1. Avante.nvim - Cursor 风格的 AI IDE

- **功能**: 类似 Cursor AI IDE 的体验，支持代码生成、重构和智能建议
- **提供商**: 支持 OpenRouter、Claude、DeepSeek 等多种 AI 模型
- **如何接受 AI 补全建议**:
  - **主要方式**: `<M-l>` (Alt+L) - 接受当前 AI 建议
  - **导航**: `<M-]>` (Alt+]) - 下一个建议，`<M-[>` (Alt+[) - 上一个建议
  - **取消**: `<C-]>` (Ctrl+]) - 取消当前建议
  - **Tab 流**: 在支持的模式下，也可以使用 `Tab` 键接受建议
- **其他快捷键**:
  - `<leader>aa`: 显示 AI 侧边栏
  - `<leader>at`: 切换侧边栏可见性
  - `<leader>ar`: 刷新侧边栏
  - `<leader>af`: 切换侧边栏焦点
  - `<leader>aS`: 停止当前 AI 请求

#### 2. Aider - 命令行 AI 编程助手

- **功能**: 通过命令行界面与 AI 进行代码协作
- **快捷键**:
  - `<leader>A/`: 切换 Aider
  - `<leader>As`: 发送到 Aider
  - `<leader>Ac`: Aider 命令
  - `<leader>Ab`: 发送缓冲区
  - `<leader>A+`: 添加文件
  - `<leader>A-`: 移除文件

#### 3. Claude Code - Claude AI 集成

- **功能**: 直接集成 Claude AI 进行代码分析和生成

#### 4. ChatGPT.nvim - GPT 聊天界面

- **功能**: 在 Neovim 中直接与 ChatGPT 交互
- **命令**: `:ChatGPT`, `:ChatGPTActAs`, `:ChatGPTEditWithInstructions`

#### 5. AI Commit - 智能提交信息生成

- **功能**: 使用 AI 自动生成 Git 提交信息
- **支持模型**: Qwen、Claude、DeepSeek、Gemini 等

#### 6. CodeCompanion - 多模态 AI 编程助手

- **功能**: 支持文本、代码和图像的多模态 AI 交互
- **特色**: 与 MCPHub 深度集成，提供增强的工具访问
- **优势**: 
  - 多模态输入支持（文本、代码、图像）
  - 丰富的预设提示模板
  - 灵活的聊天和内联编辑模式
  - 支持多种 AI 提供商

#### 7. CopilotChat - GitHub Copilot 聊天界面

- **功能**: GitHub Copilot 的聊天界面，专注于代码相关任务
- **快捷键**: 使用 `<leader>cc` 前缀避免与 Avante 冲突
  - `<leader>ccp` - 提示动作选择
  - `<leader>cce` - 解释代码
  - `<leader>cct` - 生成测试
  - `<leader>ccr` - 代码审查
  - `<leader>ccR` - 重构代码
  - `<leader>ccn` - 改进命名
  - `<leader>cci` - 自定义提问
  - `<leader>ccm` - 生成提交信息
  - `<leader>ccf` - 修复诊断错误
  - `<leader>ccT` - 切换聊天窗口
- **优势**: 
  - 专为代码任务优化
  - 丰富的预设提示模板
  - 支持可视化选择和内联编辑

#### 8. MCPHub - 模型上下文协议

- **功能**: 支持 MCP 协议，增强 AI 工具的互操作性
- **集成**: 与 Avante、CodeCompanion 深度集成，支持斜杠命令

##### 如何在 Avante 中使用 MCPHub

**配置说明**:

- 已配置自动将 MCP 服务器状态添加到 Avante 系统提示
- 提供 `use_mcp_tool` 和 `access_mcp_resource` 自定义工具
- 支持 `/mcp:server_name:prompt_name` 斜杠命令

**使用步骤**:

1. **启动 MCP 服务器**: 使用 `:MCPHub` 命令打开 UI，启动需要的服务器
2. **在 Avante 中对话**: 打开 Avante 聊天 (`<leader>aa`)，MCP 工具会自动集成
3. **使用斜杠命令**: 输入 `/mcp:` 查看可用的 MCP 提示命令
4. **工具调用**: Avante 会在需要时自动调用 MCP 工具

**自动批准配置**:

- **全局自动批准**: 在 MCPHub UI 中按 `ga` 切换
- **服务器级别**: 按 `a` 在服务器行切换自动批准
- **工具级别**: 按 `a` 在单个工具上切换自动批准

**工具冲突处理**:
如果使用 MCPHub 内置工具，建议在 Avante 配置中禁用重复工具：

```lua
disabled_tools = {
  "list_files", "search_files", "read_file",
  "create_file", "rename_file", "delete_file",
  "create_dir", "rename_dir", "delete_dir", "bash"
}
```

## 🚀 AI 编程工作流最佳实践

### 多 AI 助手协同使用策略

本配置提供了多个 AI 编程助手，每个都有其独特优势。以下是推荐的使用策略：

#### 1. 按场景选择 AI 助手

**🎯 实时代码生成和补全 - 使用 Avante**
- **场景**: 边写代码边获得智能建议
- **快捷键**: `<leader>aa` 打开侧边栏，`<M-l>` 接受建议
- **优势**: 类似 Cursor AI IDE 的流畅体验，支持多种模型
- **最佳用途**: 新功能开发、代码框架搭建

**🔧 专业代码任务 - 使用 CopilotChat**
- **场景**: 需要针对性的代码分析和优化
- **快捷键**: `<leader>cc*` 系列命令
- **优势**: 专门优化的代码任务模板
- **最佳用途**: 
  - 代码审查 (`<leader>ccr`)
  - 生成测试 (`<leader>cct`) 
  - 代码重构 (`<leader>ccR`)
  - 解释复杂逻辑 (`<leader>cce`)

**💬 多模态交互 - 使用 CodeCompanion**
- **场景**: 需要处理图像、复杂对话或自定义工作流
- **优势**: 支持图像输入、灵活的对话模式
- **最佳用途**: 架构设计讨论、需求分析、多媒体内容处理

**🔄 协作式编程 - 使用 Aider**
- **场景**: 大型重构、跨文件修改
- **快捷键**: `<leader>A*` 系列命令
- **优势**: 整个项目上下文感知
- **最佳用途**: 重大功能变更、代码库现代化

#### 2. 工作流组合示例

**🏗️ 新功能开发流程**
```
1. Avante (`<leader>aa`) - 生成初始代码框架
2. CopilotChat (`<leader>cct`) - 为新功能生成测试
3. CopilotChat (`<leader>ccr`) - 审查生成的代码
4. AI Commit - 自动生成规范的提交信息
```

**🐛 Bug 修复流程**
```
1. CopilotChat (`<leader>ccf`) - 分析诊断错误
2. Avante - 实时修复代码
3. CopilotChat (`<leader>cct`) - 生成回归测试
4. Code Runner (`<leader>e`) - 验证修复效果
```

**🔄 代码重构流程**
```
1. CopilotChat (`<leader>ccr`) - 分析现有代码质量
2. Aider (`<leader>A/`) - 执行大规模重构
3. CopilotChat (`<leader>ccn`) - 改进变量和函数命名
4. CopilotChat (`<leader>cct`) - 更新相关测试
```

**📚 学习和理解代码流程**
```
1. CopilotChat (`<leader>cce`) - 解释复杂代码段
2. CodeCompanion - 深入讨论架构设计
3. Avante - 生成相似模式的示例代码
```

#### 3. 高级技巧

**🔗 MCPHub 工具链增强**
- 启动 MCPHub (`:MCPHub`) 为所有 AI 助手提供文件系统、Git、Web 搜索等工具
- 在 Avante 中使用 `/mcp:` 斜杠命令访问外部数据
- CodeCompanion 自动集成 MCP 工具，提供更丰富的上下文

**⚡ 快速切换策略**
- 使用 `<leader>aa` 快速启动 Avante 进行实时编程
- 选中代码后用 `<leader>ccp` 选择 CopilotChat 预设任务
- 复杂问题时切换到 CodeCompanion 进行深度对话

**🎨 个性化配置**
- 根据项目类型调整 AI 模型选择
- 为常用工作流创建自定义快捷键
- 利用 which-key 提示记忆快捷键组合

#### 4. 性能优化建议

**📊 模型选择策略**
- **快速迭代**: 使用 DeepSeek Chat (速度快，成本低)
- **复杂推理**: 使用 Claude Sonnet 4 (质量高)
- **代码专业性**: 使用 GitHub Copilot (专门训练)

**⚙️ 工具配置优化**
- 启用 MCP 工具的自动批准以提高效率
- 根据项目大小调整上下文窗口
- 合理配置各工具的快捷键避免冲突

**🔧 环境变量配置**
确保设置所有必要的 API Keys 以获得最佳体验：
```bash
export OPENROUTER_API_KEY=your_key      # CodeCompanion, Avante 备用
export ANTHROPIC_API_KEY=your_key       # Claude 模型
export DEEPSEEK_API_KEY=your_key        # DeepSeek 模型  
export GITHUB_TOKEN=your_token          # Copilot, GitHub 集成
export BRAVE_API_KEY=your_key           # MCP Web 搜索 (可选)
```

### 代码执行和预览

#### Code Runner

- **功能**: 快速执行各种编程语言的代码
- **快捷键**: `<leader>e` - 执行当前文件
- **支持语言**: Python、JavaScript、Java、C/C++、Rust、Go 等
- **特殊功能**:
  - Markdown 预览（支持 Marp、LaTeX、Beamer）
  - LaTeX/Quarto 文档编译
  - 交互式参数输入

### 其他增强功能

#### 会话管理

- 支持多工作区会话保存和恢复

#### 数据库集成

- 内置数据库查询和管理功能

#### Go 语言增强

- 专门的 Go 语言开发支持和工具集成

#### 版本控制增强

- LazyGit 集成，提供可视化 Git 操作界面

### 环境要求

为了使用完整的 AI 功能，建议设置以下环境变量（详细配置见下方工作流最佳实践）：

```bash
# 主要 AI 提供商
export DEEPSEEK_API_KEY=your_deepseek_api_key       # 主要模型，性价比高
export ANTHROPIC_API_KEY=your_anthropic_api_key     # Claude 系列模型
export OPENROUTER_API_KEY=your_openrouter_api_key   # 多模型接入点

# GitHub 集成
export GITHUB_TOKEN=your_github_token               # Copilot 和 Git 集成

# 可选增强功能
export OPENAI_API_KEY=your_openai_api_key          # ChatGPT 和 OpenAI 模型
export BRAVE_API_KEY=your_brave_api_key            # MCP Web 搜索功能
```

## 🛠️ Installation

#### Make a backup of your current nvim and shared folder

```bash
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

#### Create a new user repository from this template

Press the "Use this template" button above to create a new repository to store your user configuration.

You can also just clone this repository directly if you do not want to track your user configuration in GitHub.

#### Clone the repository

```bash
git clone git@github.com:meetorion/astronvim_config.git ~/.config/nvim
```

#### Start Neovim

```bash
nvim
```

## 配置

### 安装虚拟环境

```bash
conda env create -f environment.yml
```

## 效率插件推荐

### tmux集成

- [tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)
- [tmux-resizer](https://github.com/christoomey/vim-tmux-resizer)

### cpp开发

- [clangd](https://github.com/clangd/clangd)
- [clang-format](https://github.com/clangd/clang-format)
- [clang-tidy](https://github.com/clangd/clang-tidy)

### Augment.nvim配置

- [Augment.nvim](https://github.com/zbirenbaum/augment.nvim)
