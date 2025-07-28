-- if true then return end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- This will run last in the setup process and is a good place to configure
-- things like custom filetypes. This just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Configure clipboard provider
if vim.fn.has('wsl') == 1 then
  vim.g.clipboard = {
    name = 'WslClipboard',
    copy = {
      ['+'] = 'clip.exe',
      ['*'] = 'clip.exe',
    },
    paste = {
      ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
elseif vim.fn.executable('xclip') == 1 then
  vim.g.clipboard = {
    name = 'xclip',
    copy = {
      ['+'] = 'xclip -selection clipboard',
      ['*'] = 'xclip -selection primary',
    },
    paste = {
      ['+'] = 'xclip -selection clipboard -o',
      ['*'] = 'xclip -selection primary -o',
    },
    cache_enabled = 1,
  }
elseif vim.fn.executable('xsel') == 1 then
  vim.g.clipboard = {
    name = 'xsel',
    copy = {
      ['+'] = 'xsel --clipboard --input',
      ['*'] = 'xsel --primary --input',
    },
    paste = {
      ['+'] = 'xsel --clipboard --output',
      ['*'] = 'xsel --primary --output',
    },
    cache_enabled = 1,
  }
end

-- Transparency setup function
local function setup_transparency()
  -- Check if we're in a terminal that supports transparency
  local term_program = vim.env.TERM_PROGRAM or vim.env.TERMINAL_EMULATOR or "unknown"
  local term = vim.env.TERM or "unknown"
  
  -- Apply transparency settings
  local transparent_groups = {
    'Normal', 'NormalNC', 'SignColumn', 'LineNr', 'CursorLineNr',
    'EndOfBuffer', 'StatusLine', 'StatusLineNC', 'TabLine', 'TabLineFill', 'TabLineSel',
    'NormalFloat', 'FloatBorder', 'FloatTitle', 'Pmenu', 'PmenuSel', 'PmenuSbar', 'PmenuThumb'
  }
  
  -- Auto-command to ensure transparency persists
  vim.api.nvim_create_autocmd({"VimEnter", "ColorScheme"}, {
    callback = function()
      -- Small delay to ensure colorscheme is fully loaded
      vim.defer_fn(function()
        for _, group in ipairs(transparent_groups) do
          -- Check if highlight group exists before modifying
          local ok, hl = pcall(vim.api.nvim_get_hl_by_name, group, true)
          if ok then
            vim.api.nvim_set_hl(0, group, vim.tbl_extend("force", hl, { bg = "NONE", ctermbg = "NONE" }))
          end
        end
        
        -- Additional plugin-specific transparency (safe approach)
        local plugin_groups = {
          'NvimTreeNormal', 'NvimTreeNormalNC', 'NeoTreeNormal', 'NeoTreeNormalNC',
          'TelescopeNormal', 'TelescopeBorder', 'TelescopePromptNormal',
          'TelescopeResultsNormal', 'TelescopePreviewNormal'
        }
        
        for _, group in ipairs(plugin_groups) do
          local ok, hl = pcall(vim.api.nvim_get_hl_by_name, group, true)
          if ok then
            vim.api.nvim_set_hl(0, group, vim.tbl_extend("force", hl, { bg = "NONE", ctermbg = "NONE" }))
          end
        end
      end, 50)
    end,
  })
end

-- Call the transparency setup
setup_transparency()

-- Set up custom filetypes
vim.filetype.add {
  extension = {
    foo = "fooscript",
  },
  filename = {
    ["Foofile"] = "fooscript",
  },
  pattern = {
    ["~/%.config/foo/.*"] = "fooscript",
  },
}

-- Initialize Go filter system with LSP override
vim.defer_fn(function()
  local success, go_override = pcall(require, "go_lsp_override")
  if success then
    go_override.setup()
  else
    vim.notify("⚠️  Go LSP 覆盖初始化失败: " .. tostring(go_override), vim.log.levels.WARN)
  end
end, 1000) -- 延迟1秒确保所有LSP配置加载完成
