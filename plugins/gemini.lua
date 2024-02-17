return {
  "gera2ld/ai.nvim",
  dependencies = "nvim-lua/plenary.nvim",
  opts = {
    api_key = os.getenv "GEMINI_API_KEY",
    -- The locale for the content to be defined/translated into
    locale = "cn",
    -- The locale for the content in the locale above to be translated into
    alternate_locale = "zh",
    -- Gemini's answer is displayed in a popup buffer
    -- Default behaviour is not to give it the focus because it is seen as a kind of tooltip
    -- But if you prefer it to get the focus, set to true.
    result_popup_gets_focus = true,
    -- Define custom prompts here, see below for more details
    prompts = {},
  },
  event = "VeryLazy",
  -- config = function() require("ai").setup { opts } end,
}