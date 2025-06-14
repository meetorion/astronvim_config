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

#### 6. MCPHub - 模型上下文协议

- **功能**: 支持 MCP 协议，增强 AI 工具的互操作性
- **集成**: 与 Avante 深度集成，支持斜杠命令

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

为了使用 AI 功能，需要设置以下环境变量：

```bash
# OpenRouter API Key (用于 Avante 和 AI Commit)
export OPENROUTER_API_KEY=your_openrouter_api_key

# Anthropic API Key (用于 Claude)
export ANTHROPIC_API_KEY=your_anthropic_api_key

# DeepSeek API Key
export DEEPSEEK_API_KEY=your_deepseek_api_key

# OpenAI API Key (用于 ChatGPT)
export OPENAI_API_KEY=your_openai_api_key
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
