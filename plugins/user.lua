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
    "piersolenski/telescope-import.nvim",
    event = "VeryLazy",
    dependencies = "nvim-telescope/telescope.nvim",
    config = function() require("telescope").load_extension "import" end,
  },
}
