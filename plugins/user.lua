return {
  -- You can also add new plugins here as well:
  -- Add plugins, the lazy syntax
  -- "andweeb/presence.nvim",
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },
  {
    "zbirenbaum/copilot-cmp",
    event = "VeryLazy",
    config = function() require("copilot").setup() end,
  },
  {
    "sidebar-nvim/sidebar.nvim",
    event = "VeryLazy",
    config = function() require("sidebar-nvim").setup() end,
  },
}
