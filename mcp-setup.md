# MCP服务器配置指南

## 环境变量配置

为了使用所有MCP服务器功能，需要设置以下环境变量。将这些添加到你的 `~/.bashrc` 或 `~/.zshrc` 中：

```bash
# 必需的API密钥
export DEEPSEEK_API_KEY="your_deepseek_api_key"        # DeepSeek API
export ANTHROPIC_API_KEY="your_anthropic_api_key"      # Claude API (备用)
export GITHUB_TOKEN="your_github_personal_access_token" # GitHub集成
export BRAVE_API_KEY="your_brave_search_api_key"       # 网页搜索 (可选)

# 可选的API密钥
export OPENAI_API_KEY="your_openai_api_key"            # OpenAI (备用)
export OPENROUTER_API_KEY="your_openrouter_api_key"    # OpenRouter (备用)
```

## MCP服务器安装

在首次使用前，需要安装MCP服务器包：

```bash
# 安装核心MCP服务器
npm install -g @supermemory/mcp-server
npm install -g @modelcontextprotocol/server-filesystem
npm install -g @modelcontextprotocol/server-git
npm install -g @modelcontextprotocol/server-brave-search
npm install -g @modelcontextprotocol/server-sqlite
npm install -g @modelcontextprotocol/server-github
npm install -g @modelcontextprotocol/server-shell
npm install -g @modelcontextprotocol/server-memory
npm install -g @modelcontextprotocol/server-time
```

## 已配置的MCP服务器

### 1. SuperMemory (持久化记忆)
- **功能**: 跨会话的知识存储和检索
- **自动批准**: 否 (需要手动确认)
- **用途**: 存储重要的项目信息、学习内容

### 2. Filesystem (文件系统)
- **功能**: 文件和目录操作
- **自动批准**: 是 (安全操作)
- **用途**: 读取、创建、修改文件
- **根目录**: `/home/dreamaster`

### 3. Git (版本控制)
- **功能**: Git操作和仓库管理
- **自动批准**: 否 (需要手动确认)
- **用途**: 查看提交历史、分支管理、状态检查

### 4. Web Search (网页搜索)
- **功能**: 搜索网络内容和文档
- **自动批准**: 否 (需要手动确认)
- **需要**: BRAVE_API_KEY

### 5. SQLite (数据库)
- **功能**: 数据库查询和管理
- **自动批准**: 否 (需要手动确认)
- **数据库路径**: 当前工作目录下的 `data.db`

### 6. GitHub (代码仓库)
- **功能**: GitHub仓库、issue、PR管理
- **自动批准**: 否 (需要手动确认)
- **需要**: GITHUB_TOKEN

### 7. Shell (终端命令)
- **功能**: 执行shell命令
- **自动批准**: 否 (需要手动确认)
- **用途**: 运行构建命令、测试等

### 8. Memory (内存管理)
- **功能**: 会话内存储
- **自动批准**: 是 (安全操作)
- **用途**: 临时信息存储

### 9. Time (时间服务)
- **功能**: 时间相关操作
- **自动批准**: 是 (安全操作)
- **用途**: 获取时间信息、调度任务

## 使用方法

### 1. 启动MCP服务器
```
:MCPHub
```
在MCPHub界面中：
- `t` - 切换服务器状态
- `a` - 切换自动批准
- `r` - 刷新
- `q` - 退出

### 2. 在Avante中使用
- 打开Avante: `<leader>aa`
- MCP工具会自动集成到对话中
- 使用斜杠命令: `/mcp:server_name:command`

### 3. 常用场景

**代码分析**:
```
"分析这个项目的结构，并检查最近的git提交"
```

**文档搜索**:
```
"搜索Vue.js的最新文档，找到关于Composition API的信息"
```

**数据库操作**:
```
"创建一个用户表，包含id、name和email字段"
```

## 安全注意事项

1. **Git操作**: 所有git命令需要手动确认
2. **Shell命令**: 危险命令需要手动审批
3. **文件操作**: 基本操作已设为自动批准
4. **网络请求**: 搜索操作需要手动确认

## 故障排除

### 常见问题

1. **MCP服务器启动失败**:
   - 检查npm包是否正确安装
   - 确认环境变量已设置

2. **API密钥错误**:
   - 重新生成API密钥
   - 检查环境变量名称是否正确

3. **权限问题**:
   - 确保文件系统有适当权限
   - GitHub token有必要的scope

### 调试命令
```bash
# 检查MCP包安装
npm list -g | grep mcp

# 测试环境变量
echo $DEEPSEEK_API_KEY

# 重新安装MCPHub
npm install -g mcp-hub@latest
```