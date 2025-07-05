-- Temporary fix for Avante.nvim spinner_char nil error
-- This file patches the sidebar module to handle nil spinner_char gracefully

local M = {}

function M.apply_fix()
  -- Only apply fix if avante is loaded
  local ok, avante = pcall(require, "avante")
  if not ok then
    return
  end

  -- Check if sidebar module exists
  local sidebar_ok, sidebar = pcall(require, "avante.sidebar")
  if not sidebar_ok then
    return
  end

  -- Patch the spinner functionality
  local original_render_state = sidebar.render_state
  if original_render_state then
    sidebar.render_state = function(...)
      local args = {...}
      -- Wrap in pcall to catch the spinner_char error
      local success, result = pcall(original_render_state, unpack(args))
      if not success then
        -- If error contains spinner_char, return empty or fallback
        if string.match(result, "spinner_char") then
          return "" -- or return a fallback spinner character
        else
          error(result) -- re-throw other errors
        end
      end
      return result
    end
  end
end

-- Auto-apply fix when module is loaded
M.apply_fix()

return M