-- Fix gd (Go to Definition) for Java files
-- 修复 Java 文件中的 gd 跳转问题

local M = {}

-- 检查并修复 gd 键位映射
function M.fix_gd_mapping()
    print("=== 修复 gd 键位映射 ===")
    
    -- 1. 为当前缓冲区创建强制的 gd 映射
    local function setup_gd_mapping(bufnr)
        local opts = { 
            buffer = bufnr or 0, 
            silent = true, 
            noremap = true,
            desc = "Go to definition (fixed)"
        }
        
        -- 强制设置 gd 映射，覆盖任何现有映射
        vim.keymap.set("n", "gd", function()
            print("执行 gd 跳转...")
            
            -- 检查 LSP 客户端
            local clients = vim.lsp.get_active_clients({bufnr = bufnr or 0})
            if #clients == 0 then
                print("错误：没有活跃的 LSP 客户端")
                return
            end
            
            -- 检查是否支持跳转到定义
            local has_definition = false
            for _, client in ipairs(clients) do
                if client.server_capabilities.definitionProvider then
                    has_definition = true
                    break
                end
            end
            
            if not has_definition then
                print("错误：LSP 服务器不支持跳转到定义")
                return
            end
            
            -- 执行跳转
            vim.lsp.buf.definition()
        end, opts)
        
        print("✓ gd 映射已设置到缓冲区", bufnr or vim.api.nvim_get_current_buf())
    end
    
    -- 2. 为当前缓冲区设置映射
    setup_gd_mapping()
    
    -- 3. 为所有 Java 文件设置自动命令
    vim.api.nvim_create_autocmd({"FileType"}, {
        pattern = "java",
        callback = function(args)
            vim.defer_fn(function()
                setup_gd_mapping(args.buf)
            end, 100) -- 短暂延迟确保 LSP 已加载
        end,
        desc = "Setup gd mapping for Java files"
    })
    
    -- 4. LSP attach 时重新设置映射
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client and (client.name == "jdtls" or client.name:match("java")) then
                vim.defer_fn(function()
                    setup_gd_mapping(args.buf)
                end, 500) -- 延迟确保 LSP 完全就绪
            end
        end,
        desc = "Setup gd mapping on LSP attach"
    })
    
    print("✓ gd 修复完成！现在可以使用 gd 跳转了")
end

-- 诊断 gd 问题
function M.diagnose_gd()
    print("=== 诊断 gd 问题 ===")
    
    local buf = vim.api.nvim_get_current_buf()
    local bufname = vim.api.nvim_buf_get_name(buf)
    
    print("当前文件:", bufname)
    print("文件类型:", vim.bo.filetype)
    
    -- 检查 LSP 客户端
    local clients = vim.lsp.get_active_clients({bufnr = buf})
    print("活跃的 LSP 客户端数量:", #clients)
    
    for i, client in ipairs(clients) do
        print(string.format("  %d. %s (支持定义跳转: %s)", 
            i, 
            client.name, 
            client.server_capabilities.definitionProvider and "是" or "否"
        ))
    end
    
    -- 检查当前的 gd 键位映射
    local keymaps = vim.api.nvim_buf_get_keymap(buf, 'n')
    local found_gd = false
    
    for _, keymap in ipairs(keymaps) do
        if keymap.lhs == 'gd' then
            print("找到缓冲区 gd 映射:", keymap.desc or "无描述")
            found_gd = true
        end
    end
    
    if not found_gd then
        -- 检查全局映射
        local global_keymaps = vim.api.nvim_get_keymap('n')
        for _, keymap in ipairs(global_keymaps) do
            if keymap.lhs == 'gd' then
                print("找到全局 gd 映射:", keymap.desc or "无描述")
                found_gd = true
            end
        end
    end
    
    if not found_gd then
        print("⚠️  未找到 gd 键位映射！")
    end
    
    print("=== 诊断完成 ===")
end

-- 全面修复
function M.comprehensive_fix()
    M.diagnose_gd()
    print("")
    M.fix_gd_mapping()
    
    -- 额外设置其他常用的 LSP 键位
    local opts = { buffer = 0, silent = true, noremap = true }
    
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, 
        vim.tbl_extend("force", opts, {desc = "Go to declaration"}))
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, 
        vim.tbl_extend("force", opts, {desc = "Go to implementation"}))
    vim.keymap.set("n", "gr", vim.lsp.buf.references, 
        vim.tbl_extend("force", opts, {desc = "Show references"}))
    vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, 
        vim.tbl_extend("force", opts, {desc = "Go to type definition"}))
    vim.keymap.set("n", "K", vim.lsp.buf.hover, 
        vim.tbl_extend("force", opts, {desc = "Show hover info"}))
    
    print("✓ 所有 LSP 键位映射已设置")
end

-- 创建用户命令
vim.api.nvim_create_user_command("FixGd", M.comprehensive_fix, {
    desc = "Fix gd (Go to Definition) mapping for current buffer"
})

vim.api.nvim_create_user_command("DiagnoseGd", M.diagnose_gd, {
    desc = "Diagnose gd mapping issues"
})

-- 导出到全局作用域
_G.FixGd = M

-- 自动执行修复（如果当前是 Java 文件）
if vim.bo.filetype == "java" then
    vim.defer_fn(M.comprehensive_fix, 1000)
end

return M