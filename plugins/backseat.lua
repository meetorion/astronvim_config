local config = {
  openai_api_key = os.getenv "OPENAI_API_KEY",
  openai_model_id = "gpt-4", --gpt-4 (If you do not have access to a model, it says "The model does not exist")
  language = "chinese", -- Such as 'japanese', 'french', 'pirate', 'LOLCAT'
}
return {
  "meetorion/backseat.nvim",
  event = "VeryLazy",
  opts = config,
}
