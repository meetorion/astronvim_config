# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is an AstroNvim v4+ configuration repository focused on AI-enhanced development workflows. The configuration integrates multiple AI coding assistants (Avante, Aider, MCPHub) with comprehensive language support and development tools.

## Key Architecture

- **Plugin System**: Lazy.nvim package manager with AstroNvim framework
- **Configuration Structure**: 
  - `init.lua` - Bootstrap file (avoid editing)
  - `lua/lazy_setup.lua` - Main Lazy configuration
  - `lua/community.lua` - AstroCommunity packs (Go, Python, TypeScript, Rust, C++)
  - `lua/plugins/` - Custom plugin configurations
  - `lua/polish.lua` - Final setup customizations

## Essential Commands

### Development Environment
```bash
# Setup Python environment (required for some plugins)
conda env create -f environment.yml
conda activate arch

# Install recommended modern CLI tools for optimal Avante experience
sudo pacman -S --needed eza htop tree dust procs
# Most tools (fd, ripgrep, bat) are already installed

# Neovim package management
nvim  # First run will auto-install plugins via Lazy.nvim
```

### Code Execution
- `<leader>e` - Execute current file (supports Python, JS, C/C++, Rust, Go, V, LaTeX, Quarto, Markdown)
- Languages auto-detect and use appropriate runners  
- LaTeX files compile with Tectonic and preview with Zathura
- Quarto files preview on port 4444
- Markdown files support Marp, LaTeX, and Beamer compilation

### AI Assistant Usage

#### Avante (Primary AI Assistant)
- **Models**: DeepSeek Chat (primary), DeepSeek Reasoner, Claude Sonnet 4
- **MCP Integration**: 9 MCP servers for comprehensive tool access
- **Linux/zsh Optimization**: Configured for native Linux environment with zsh shell preferences
- **Key Mappings**:
  - `<leader>aa` - Ask Avante
  - `<leader>ae` - Edit with Avante  
  - `<leader>at` - Toggle sidebar
  - `<leader>ar` - Refresh
  - `<leader>af` - Focus sidebar
  - `<M-l>` - Accept AI suggestion
  - `<M-]>` / `<M-[>` - Navigate suggestions
  - `<C-]>` - Dismiss suggestions

**Arch Linux/zsh Specific Features**:
- Prefers zsh syntax and idioms over bash
- Uses modern CLI tools: `fd` over `find`, `rg` over `grep`, `bat` over `cat`, `eza` over `ls`
- Custom tools for zsh glob patterns and Arch Linux system information
- Arch package management integration: pacman, yay/paru for AUR
- Optimized for Arch Linux development workflows with rolling release considerations
- Arch Wiki integration for documentation references

#### MCP Servers (Model Context Protocol)
**Available Tools**:
1. **SuperMemory** - Persistent knowledge storage
2. **Filesystem** - File/directory operations (auto-approved)
3. **Git** - Version control operations  
4. **Web Search** - Brave search integration
5. **SQLite** - Database operations
6. **GitHub** - Repository management
7. **Shell** - Terminal command execution
8. **Memory** - Session memory (auto-approved)
9. **Time** - Time operations (auto-approved)

**Usage**: `:MCPHub` to manage servers, slash commands in Avante (`/mcp:server:command`)

#### Aider (Collaborative AI)
- `<leader>A/` - Toggle Aider interface
- `<leader>As` - Send selection to Aider
- `<leader>Ac` - Aider command palette
- `<leader>Ab` - Send buffer to Aider
- `<leader>A+` / `<leader>A-` - Add/remove files from session

### Buffer and Navigation
- `]b` / `[b` - Next/previous buffer
- `<leader>bd` - Interactive buffer close picker
- `gD` - Go to symbol declaration
- `<leader>uY` - Toggle semantic highlighting

### Additional AI Tools
#### CodeCompanion
- Alternative AI coding assistant with chat interface
- Integrates with multiple LLM providers

#### AI Commit
- Automatic commit message generation using AI
- Supports multiple models: Qwen, Claude, DeepSeek, Gemini

## Configuration Patterns

### Plugin Structure
Each plugin file in `lua/plugins/` follows AstroNvim's spec format:
```lua
return {
  "plugin/name",
  opts = {
    -- configuration
  },
  config = function(_, opts)
    -- custom setup
  end
}
```

### Language Support
- LSP configurations in `astrolsp.lua`
- Language packs imported via `community.lua`
- Format-on-save enabled globally with 1000ms timeout
- Semantic tokens and code lens enabled

### AI Integration Architecture
- **Avante**: Direct code generation and editing
- **MCP Hub**: External tool and data source access
- **Aider**: Collaborative coding sessions
- All AI tools can access project context via MCP protocol

## Important Files to Understand

- `lua/plugins/astrocore.lua` - Core functionality and keybindings
- `lua/plugins/astrolsp.lua` - LSP behavior and formatting  
- `lua/plugins/avante.lua` - Primary AI assistant configuration
- `lua/plugins/coder_runner.lua` - Code execution mappings
- `lua/plugins/mcphub.lua` - External tool integration
- `lua/plugins/codecompanion.lua` - Additional AI assistant integration
- `lua/plugins/aicommit.lua` - AI-powered commit message generation

## Environment Variables Required

### Required for AI functionality:
```bash
export DEEPSEEK_API_KEY="your_deepseek_api_key"        # Primary AI provider
export ANTHROPIC_API_KEY="your_anthropic_api_key"      # Claude models (backup)
```

### Required for MCP servers:
```bash
export GITHUB_TOKEN="your_github_personal_access_token" # GitHub integration
export BRAVE_API_KEY="your_brave_search_api_key"       # Web search (optional)
```

### Optional:
```bash
export OPENAI_API_KEY="your_openai_api_key"            # OpenAI features
export OPENROUTER_API_KEY="your_openrouter_api_key"    # OpenRouter (backup)
```

**Setup**: See `mcp-setup.md` for detailed MCP server installation and configuration.

## Development Workflow

1. **Setup MCP Environment**: 
   - Install MCP servers: `npm install -g @supermemory/mcp-server @modelcontextprotocol/server-*`
   - Configure environment variables (see `mcp-setup.md`)
   - Start servers: `:MCPHub`

2. **AI-Enhanced Coding**:
   - Use Avante (`<leader>aa`) for code generation with full project context
   - MCP tools provide file system, git, and web search capabilities
   - SuperMemory stores important project knowledge across sessions

3. **Code Execution**: Use `<leader>e` for language-specific execution
4. **Version Control**: Git operations via MCP or traditional git commands  
5. **Collaborative AI**: Use Aider for pair-programming style assistance

## Debugging and Maintenance

- Large files (>256KB or >10,000 lines) automatically disable some features for performance
- LSP timeout set to 1000ms for formatting operations
- Lazy.nvim handles plugin installation and updates automatically
- Check `:checkhealth` for diagnostic information