-- fix-java-lsp.lua
-- 修复 Java LSP 无法识别类型的问题

local M = {}

function M.fix_java_lsp()
  print("开始修复 Java LSP...")
  
  -- 1. 停止当前的 LSP
  vim.cmd("LspStop jdtls")
  
  -- 2. 清理工作区
  local workspace_dir = vim.fn.expand("~/.cache/jdtls/workspace")
  vim.fn.system("rm -rf " .. workspace_dir)
  print("已清理 jdtls 工作区")
  
  -- 3. 重启 LSP
  vim.defer_fn(function()
    vim.cmd("LspStart jdtls")
    print("Java LSP 已重启")
  end, 1000)
  
  -- 4. 强制重新索引
  vim.defer_fn(function()
    if vim.lsp.get_active_clients({name = "jdtls"})[1] then
      vim.lsp.buf.workspace_symbol("")
      print("正在重新索引项目...")
    end
  end, 3000)
end

-- 创建用户命令
vim.api.nvim_create_user_command("JavaFixLSP", function()
  M.fix_java_lsp()
end, { desc = "修复 Java LSP 类型识别问题" })

-- 自动修复功能
function M.setup_auto_fix()
  vim.api.nvim_create_autocmd("LspAttach", {
    pattern = "*.java",
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client.name == "jdtls" then
        -- 检查是否有类型识别问题
        vim.defer_fn(function()
          local diagnostics = vim.diagnostic.get(0)
          for _, diag in ipairs(diagnostics) do
            if diag.message:match("cannot be resolved to a type") then
              print("检测到类型识别问题，尝试自动修复...")
              -- 触发工作区刷新
              vim.lsp.buf.execute_command({
                command = "java.project.reload",
                arguments = {}
              })
              break
            end
          end
        end, 2000)
      end
    end,
  })
end

return M