-- 增强的 Telescope 配置，支持智能过滤
-- 与 go_filter_manager 集成

return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = function(_, opts)
    local actions = require "telescope.actions"
    local filter_manager = require "go_filter_manager"
    
    -- 深度合并配置
    local function deep_merge(target, source)
      for key, value in pairs(source) do
        if type(value) == "table" and type(target[key]) == "table" then
          deep_merge(target[key], value)
        else
          target[key] = value
        end
      end
      return target
    end
    
    local enhanced_config = {
      defaults = {
        file_ignore_patterns = {
          -- 基础排除模式（这些总是被排除）
          "%.git/",
          "node_modules/",
          "%.DS_Store",
          "__pycache__/",
          "%.pyc$",
          "%.pyo$",
        },
        
        -- 使用ripgrep进行搜索，动态添加排除模式
        vimgrep_arguments = {
          'rg',
          '--color=never',
          '--no-heading',
          '--with-filename', 
          '--line-number',
          '--column',
          '--smart-case',
          '--hidden',
        },
      },
      
      pickers = {
        find_files = {
          -- 动态生成find命令，基于当前过滤状态
          find_command = function()
            local cmd = { 'fd', '--type', 'f', '--hidden', '--color', 'never' }
            
            -- 添加基础排除
            vim.list_extend(cmd, { '--exclude', '.git' })
            
            -- 根据过滤状态添加排除模式
            local excludes = filter_manager.get_fd_excludes()
            vim.list_extend(cmd, excludes)
            
            return cmd
          end,
        },
        
        live_grep = {
          additional_args = function()
            return filter_manager.get_rg_excludes()
          end,
        },
        
        grep_string = {
          additional_args = function()
            return filter_manager.get_rg_excludes()
          end,
        },
      },
    }
    
    return deep_merge(opts or {}, enhanced_config)
  end,
  
  keys = {
    -- 重新定义 ff 映射，添加状态显示
    {
      "<Leader>ff",
      function()
        local filter_manager = require "go_filter_manager"
        local status = filter_manager.get_status_text()
        
        vim.notify(
          string.format("🔍 文件搜索 [%s]", status),
          vim.log.levels.INFO,
          { title = "Telescope", timeout = 1000 }
        )
        
        require("telescope.builtin").find_files()
      end,
      desc = "Find files (智能过滤)",
    },
    
    -- 强制包含所有文件的搜索
    {
      "<Leader>fF",
      function()
        require("telescope.builtin").find_files({
          find_command = { 'fd', '--type', 'f', '--hidden', '--color', 'never', '--exclude', '.git' },
        })
      end,
      desc = "Find ALL files (无过滤)",
    },
    
    -- 增强的 live grep
    {
      "<Leader>fg",
      function()
        local filter_manager = require "go_filter_manager"
        local status = filter_manager.get_status_text()
        
        vim.notify(
          string.format("🔍 内容搜索 [%s]", status),
          vim.log.levels.INFO,
          { title = "Telescope", timeout = 1000 }
        )
        
        require("telescope.builtin").live_grep()
      end,
      desc = "Live grep (智能过滤)",
    },
    
    -- 强制搜索所有文件内容
    {
      "<Leader>fG",
      function()
        require("telescope.builtin").live_grep({
          additional_args = { "--hidden" },
        })
      end,
      desc = "Live grep ALL (无过滤)",
    },
  },
}