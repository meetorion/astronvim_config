return {
  "meetorion/CodeGPT.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  event = "VeryLazy",
  opts = {},
  config = function() require "codegpt.config" end,
}
