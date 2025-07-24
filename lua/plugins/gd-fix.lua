-- 自动修复 gd 键位映射问题
-- Auto-fix gd (Go to Definition) mapping issues

return {
  "neovim/nvim-lspconfig",
  opts = function()
    -- 确保 gd 键位在所有情况下都能正常工作
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("fix-gd-mapping", { clear = true }),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local bufnr = args.buf
        
        -- 为所有支持定义跳转的 LSP 客户端设置键位映射
        if client and client.server_capabilities.definitionProvider then
          local opts = { 
            buffer = bufnr, 
            silent = true, 
            noremap = true,
            desc = "Go to definition (auto-fixed)"
          }
          
          -- 延迟设置键位映射，确保不被其他配置覆盖
          vim.defer_fn(function()
            vim.keymap.set("n", "gd", function()
              vim.lsp.buf.definition()
            end, opts)
            
            -- 同时设置其他相关键位
            vim.keymap.set("n", "gD", function()
              vim.lsp.buf.declaration()
            end, vim.tbl_extend("force", opts, {desc = "Go to declaration"}))
            
            vim.keymap.set("n", "gi", function()
              vim.lsp.buf.implementation()
            end, vim.tbl_extend("force", opts, {desc = "Go to implementation"}))
            
            vim.keymap.set("n", "gr", function()
              vim.lsp.buf.references()
            end, vim.tbl_extend("force", opts, {desc = "Show references"}))
            
            vim.keymap.set("n", "gy", function()
              vim.lsp.buf.type_definition()
            end, vim.tbl_extend("force", opts, {desc = "Go to type definition"}))
            
            vim.keymap.set("n", "K", function()
              vim.lsp.buf.hover()
            end, vim.tbl_extend("force", opts, {desc = "Show hover documentation"}))
            
            -- 调试信息（可选）
            if client.name == "jdtls" then
              print(string.format("✓ gd 键位已为 %s 设置 (缓冲区 %d)", client.name, bufnr))
            end
          end, 200) -- 延迟 200ms 确保其他配置加载完成
        end
      end,
    })
    
    -- 为 Java 文件特别处理
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "java",
      group = vim.api.nvim_create_augroup("java-gd-fix", { clear = true }),
      callback = function(args)
        local bufnr = args.buf
        
        -- 等待 LSP 客户端附加
        local function setup_java_keys()
          local clients = vim.lsp.get_active_clients({bufnr = bufnr})
          local java_client = nil
          
          for _, client in ipairs(clients) do
            if client.name == "jdtls" or client.name:match("java") then
              java_client = client
              break
            end
          end
          
          if java_client and java_client.server_capabilities.definitionProvider then
            local opts = { 
              buffer = bufnr, 
              silent = true, 
              noremap = true,
              desc = "Go to definition (Java specific)"
            }
            
            vim.keymap.set("n", "gd", function()
              vim.lsp.buf.definition()
            end, opts)
            
            print("✓ Java gd 键位已设置")
          else
            -- 如果 LSP 还没准备好，稍后重试
            vim.defer_fn(setup_java_keys, 1000)
          end
        end
        
        -- 延迟设置，给 LSP 时间启动
        vim.defer_fn(setup_java_keys, 500)
      end,
    })
    
    -- 创建用户命令用于手动修复
    vim.api.nvim_create_user_command("FixGdNow", function()
      local bufnr = vim.api.nvim_get_current_buf()
      local clients = vim.lsp.get_active_clients({bufnr = bufnr})
      
      if #clients == 0 then
        print("错误：当前缓冲区没有活跃的 LSP 客户端")
        return
      end
      
      local opts = { 
        buffer = bufnr, 
        silent = true, 
        noremap = true,
        desc = "Go to definition (manually fixed)"
      }
      
      vim.keymap.set("n", "gd", function()
        vim.lsp.buf.definition()
      end, opts)
      
      print("✓ gd 键位已手动修复")
    end, {
      desc = "Manually fix gd key mapping for current buffer"
    })
  end,
}