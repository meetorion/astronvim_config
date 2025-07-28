-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = false, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
        -- File handling optimizations
        hidden = true, -- allow hidden buffers
        updatetime = 300, -- faster completion (default 4000ms)
        timeoutlen = 500, -- timeout for mapped sequences
        -- Reduce file watching overhead
        swapfile = false, -- disable swap files
        backup = false, -- disable backup files
        writebackup = false, -- disable writebackup
        -- Clipboard integration
        clipboard = "unnamedplus", -- use system clipboard as default register
        -- Tab and indentation settings
        tabstop = 2, -- A tab is 2 spaces
        softtabstop = 2, -- When hitting <BS>, pretend like a tab is removed even if spaces
        shiftwidth = 2, -- Number of spaces to use for autoindenting
        expandtab = true, -- Use spaces instead of tabs
        smarttab = true, -- Use 'shiftwidth' when inserting <Tab>
        autoindent = true, -- Copy indent from current line when starting a new line
        smartindent = true, -- Smart autoindenting when starting a new line
        -- Show whitespace characters (minimal display)
        list = false, -- Don't show whitespace characters by default
        listchars = { tab = "  ", trail = "·", extends = "⟩", precedes = "⟨", nbsp = "⦸" },
        -- Tab line display
        showtabline = 2, -- Always show tabline
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,
        
        -- Clipboard mappings
        ["<Leader>y"] = { '"+y', desc = "Copy to system clipboard" },
        ["<Leader>Y"] = { '"+Y', desc = "Copy line to system clipboard" },
        ["<Leader>p"] = { '"+p', desc = "Paste from system clipboard after cursor" },
        ["<Leader>P"] = { '"+P', desc = "Paste from system clipboard before cursor" },
        
        -- Toggle transparency
        ["<Leader>ut"] = {
          function()
            require("transparent").toggle()
          end,
          desc = "Toggle transparency",
        },
        
        -- Toggle whitespace display (for debugging only)
        ["<Leader>uw"] = {
          function()
            vim.opt.list = not vim.opt.list:get()
            if vim.opt.list:get() then
              print("Whitespace visible")
            else
              print("Whitespace hidden") 
            end
          end,
          desc = "Toggle whitespace display",
        },
        
        -- Toggle gitignored files in NeoTree
        ["<Leader>ug"] = {
          function()
            require("toggle-gitignore").toggle()
          end,
          desc = "Toggle gitignored files in NeoTree",
        },
        
        -- Go过滤器切换功能
        ["<Leader>gt"] = {
          function()
            require("go_filter_manager").toggle_tests()
          end,
          desc = "切换测试文件显示 (gr/ff)",
        },
        
        ["<Leader>gv"] = {
          function()
            require("go_filter_manager").toggle_vendor()
          end,
          desc = "切换vendor目录显示 (ff)",
        },
        
        -- 显示当前过滤状态
        ["<Leader>gs"] = {
          function()
            local filter_manager = require("go_filter_manager")
            local status = filter_manager.get_status_text()
            local details = string.format(
              "过滤状态:\n• 测试文件: %s\n• Vendor目录: %s",
              filter_manager.state.include_tests and "包含" or "排除",
              filter_manager.state.include_vendor and "包含" or "排除"
            )
            
            vim.notify(details, vim.log.levels.INFO, { title = "Go过滤管理器" })
          end,
          desc = "显示Go过滤状态",
        },
        
        -- 调试命令
        ["<Leader>gd"] = {
          function()
            require("debug_go_filter").full_diagnosis()
          end,
          desc = "Go过滤器完整诊断",
        },
        
        ["<Leader>gr"] = {
          function()
            require("debug_go_filter").manual_filtered_references()
          end,
          desc = "手动触发过滤引用查找",
        },
        
        ["<Leader>gR"] = {
          function()
            require("debug_go_filter").reload_config()
          end,
          desc = "重新加载Go过滤配置",
        },
        
        ["<Leader>gD"] = {
          function()
            require("go_filter_manager").toggle_debug()
          end,
          desc = "切换Go过滤器调试模式",
        },
        
        ["<Leader>gT"] = {
          function()
            require("test_go_filter").run_all_tests()
          end,
          desc = "运行Go过滤器测试套件",
        },
      },
      -- Visual mode mappings
      v = {
        -- Clipboard mappings for visual mode
        ["<Leader>y"] = { '"+y', desc = "Copy selection to system clipboard" },
        ["<Leader>d"] = { '"+d', desc = "Cut selection to system clipboard" },
        ["<Leader>p"] = { '"+p', desc = "Paste from system clipboard (replace selection)" },
      },
    },
  },
}
