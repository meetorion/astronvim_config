-- Java LSP 修复工具
-- 使用方法：在 Neovim 中执行 :luafile ~/.config/nvim/lua/java-fix.lua

local M = {}

-- 修复 Java LSP 跳转问题
function M.fix_java_goto()
    print("=== 修复 Java LSP 跳转问题 ===")
    
    -- 1. 检查当前缓冲区是否是 Java 文件
    local bufname = vim.api.nvim_buf_get_name(0)
    if not string.match(bufname, "%.java$") then
        print("错误：当前文件不是 Java 文件")
        return
    end
    
    -- 2. 检查 LSP 客户端
    local clients = vim.lsp.get_active_clients({bufnr = 0})
    local jdtls_client = nil
    
    for _, client in ipairs(clients) do
        if client.name == "jdtls" then
            jdtls_client = client
            break
        end
    end
    
    if not jdtls_client then
        print("未找到 JDTLS 客户端，正在重新启动...")
        -- 重新启动 LSP
        vim.cmd("LspRestart")
        vim.defer_fn(function()
            print("LSP 重启完成，请等待几秒钟让服务器初始化")
        end, 2000)
        return
    end
    
    print("找到 JDTLS 客户端，状态:", jdtls_client.is_stopped() and "停止" or "运行")
    
    -- 3. 检查服务器能力
    local caps = jdtls_client.server_capabilities
    if caps and caps.definitionProvider then
        print("✓ 支持跳转到定义")
    else
        print("✗ 不支持跳转到定义")
    end
    
    -- 4. 强制重新设置键绑定
    local opts = { buffer = 0, silent = true, noremap = true }
    
    vim.keymap.set("n", "gd", function()
        print("执行跳转到定义...")
        vim.lsp.buf.definition()
    end, opts)
    
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    
    print("✓ 键绑定已重新设置")
    
    -- 5. 测试跳转功能
    print("测试跳转功能 (将光标置于方法调用上，然后按 gd)")
end

-- 清理 LSP 缓存
function M.clean_lsp_cache()
    print("清理 LSP 缓存...")
    local cache_dir = vim.fn.stdpath("cache") .. "/jdtls"
    vim.fn.system("rm -rf " .. cache_dir)
    print("缓存已清理，请重启 Neovim")
end

-- 重建项目索引
function M.rebuild_project()
    print("重建项目索引...")
    
    -- 发送工作区刷新命令
    for _, client in ipairs(vim.lsp.get_active_clients()) do
        if client.name == "jdtls" then
            client.request("workspace/executeCommand", {
                command = "java.clean.workspace",
                arguments = {}
            }, function(err, result)
                if err then
                    print("清理工作区失败:", err.message)
                else
                    print("工作区已清理")
                end
            end)
            
            client.request("workspace/executeCommand", {
                command = "java.project.refreshProjects",
                arguments = {}
            }, function(err, result)
                if err then
                    print("刷新项目失败:", err.message)
                else
                    print("项目已刷新")
                end
            end)
            break
        end
    end
end

-- 检查 gd 键绑定
function M.check_keybind()
    print("=== 检查 gd 键绑定 ===")
    
    local buf = vim.api.nvim_get_current_buf()
    local keymaps = vim.api.nvim_buf_get_keymap(buf, 'n')
    
    for _, keymap in ipairs(keymaps) do
        if keymap.lhs == 'gd' then
            print("找到 gd 绑定:", keymap.rhs or "LSP 函数")
            return true
        end
    end
    
    -- 检查全局绑定
    local global_keymaps = vim.api.nvim_get_keymap('n')
    for _, keymap in ipairs(global_keymaps) do
        if keymap.lhs == 'gd' then
            print("找到全局 gd 绑定:", keymap.rhs or "未知")
            return true
        end
    end
    
    print("未找到 gd 键绑定")
    return false
end

-- 综合修复
function M.comprehensive_fix()
    print("=== Java LSP 综合修复 ===")
    M.check_keybind()
    M.fix_java_goto()
    
    vim.defer_fn(function()
        M.rebuild_project()
    end, 3000)
    
    print("修复完成！请测试 gd 功能")
end

-- 导出函数供命令行使用
_G.JavaFix = M

-- 自动执行修复
M.comprehensive_fix()

return M