-- Go LSP 覆盖配置 - 确保过滤功能生效
local M = {}

-- 强制设置过滤引用映射
function M.setup_filtered_mappings(bufnr)
  local opts = { buffer = bufnr, noremap = true, silent = true }
  
  -- 强制覆盖 gr 映射
  vim.keymap.set('n', 'gr', function()
    local success, filter_manager = pcall(require, "go_filter_manager")
    if success then
      -- 包装过滤引用调用，添加错误处理
      local ok, err = pcall(filter_manager.filtered_references)
      if not ok then
        vim.notify(
          string.format("⚠️  Go过滤器执行失败: %s\n使用默认LSP引用", tostring(err)),
          vim.log.levels.WARN
        )
        vim.lsp.buf.references()
      end
    else
      vim.notify("⚠️  Go过滤器加载失败，使用默认LSP引用", vim.log.levels.WARN)
      vim.lsp.buf.references()
    end
  end, vim.tbl_extend("force", opts, { desc = "Go to references (filtered)" }))
  
  -- 添加备用映射 gR 用于原始引用
  vim.keymap.set('n', 'gR', function()
    vim.lsp.buf.references()
  end, vim.tbl_extend("force", opts, { desc = "Go to references (unfiltered)" }))
  
  vim.notify("🔧 Go过滤映射已设置到缓冲区 " .. bufnr, vim.log.levels.DEBUG)
end

-- 检查并设置 Go 文件的过滤映射
function M.on_attach(client, bufnr)
  -- 只对 Go 文件设置
  if vim.bo[bufnr].filetype == "go" then
    -- 延迟设置，确保其他配置已完成
    vim.defer_fn(function()
      M.setup_filtered_mappings(bufnr)
    end, 100)
  end
end

-- 全局设置
function M.setup()
  -- 创建自动命令组
  local augroup = vim.api.nvim_create_augroup("GoFilterOverride", { clear = true })
  
  -- 监听 LspAttach 事件
  vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup,
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client then
        M.on_attach(client, args.buf)
      end
    end,
  })
  
  -- 监听 Go 文件打开事件
  vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = "go",
    callback = function(args)
      -- 延迟设置，确保 LSP 已附加
      vim.defer_fn(function()
        if vim.lsp.get_clients({ bufnr = args.buf })[1] then
          M.setup_filtered_mappings(args.buf)
        end
      end, 500)
    end,
  })
  
  vim.notify("🚀 Go LSP 过滤覆盖已启用", vim.log.levels.DEBUG)
end

return M