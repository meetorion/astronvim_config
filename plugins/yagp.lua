return {
  "airpods69/yagp.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
  },
  event = "VeryLazy",
  config = function() require("yagp").setup {} end,
}
