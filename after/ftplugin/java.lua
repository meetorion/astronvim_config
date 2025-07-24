-- Java 文件类型特定配置
-- 修复 KrillCaMapper 等类型无法识别的问题

-- 加载修复模块
local fix_java = require("fix-java-lsp")

-- 设置自动修复
fix_java.setup_auto_fix()

-- 添加快捷键
vim.keymap.set('n', '<leader>jf', ':JavaFixLSP<CR>', { 
  buffer = true, 
  desc = "修复 Java LSP 类型识别" 
})

-- 针对 Maven 多模块项目的特殊配置
local function setup_maven_modules()
  local root_dir = vim.fn.getcwd()
  local pom_file = root_dir .. "/pom.xml"
  
  if vim.fn.filereadable(pom_file) == 1 then
    -- 读取 pom.xml 检查是否是多模块项目
    local pom_content = vim.fn.readfile(pom_file)
    local is_multi_module = false
    
    for _, line in ipairs(pom_content) do
      if line:match("<modules>") then
        is_multi_module = true
        break
      end
    end
    
    if is_multi_module then
      print("检测到 Maven 多模块项目，配置 LSP...")
      
      -- 确保 LSP 能识别所有模块
      local client = vim.lsp.get_active_clients({name = "jdtls"})[1]
      if client then
        -- 添加所有模块到类路径
        local modules = {
          "routehub-common",
          "routehub-dao", 
          "routehub-meta",
          "routehub-manager",
          "routehub-agent"
        }
        
        for _, module in ipairs(modules) do
          local module_path = root_dir .. "/" .. module .. "/target/classes"
          if vim.fn.isdirectory(module_path) == 1 then
            -- 模块已编译
          else
            print("模块 " .. module .. " 未编译，运行 mvn compile...")
          end
        end
      end
    end
  end
end

-- 延迟执行以确保 LSP 已启动
vim.defer_fn(setup_maven_modules, 1000)

-- 添加诊断信息显示
vim.keymap.set('n', '<leader>jd', function()
  local diagnostics = vim.diagnostic.get(0)
  local type_errors = {}
  
  for _, diag in ipairs(diagnostics) do
    if diag.message:match("cannot be resolved to a type") then
      table.insert(type_errors, diag.message)
    end
  end
  
  if #type_errors > 0 then
    print("发现 " .. #type_errors .. " 个类型识别错误:")
    for i, err in ipairs(type_errors) do
      print(i .. ": " .. err)
    end
    print("\n运行 :JavaFixLSP 或按 <leader>jf 尝试修复")
  else
    print("没有发现类型识别错误")
  end
end, { buffer = true, desc = "显示 Java 类型错误" })