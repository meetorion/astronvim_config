return {
  -- You can also add new plugins here as well:
  -- Add plugins, the lazy syntax
  -- "andweeb/presence.nvim",
  -- { "github/copilot.vim", event = "VeryLazy" },
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },
  {
    "piersolenski/telescope-import.nvim",
    event = "VeryLazy",
    dependencies = "nvim-telescope/telescope.nvim",
    config = function() require("telescope").load_extension "import" end,
  },
  -- {
  --   "Exafunction/codeium.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "hrsh7th/nvim-cmp",
  --   },
  --   event = { "VimEnter" },
  --   -- event = "VeryLazy",
  --   config = function() require("codeium").setup {} end,
  -- },
  { "sindrets/diffview.nvim", event = "VeryLazy" },
  -- lazy.nvim
  {
    "shuntaka9576/preview-asciidoc.vim",
    -- event = "VeryLazy",
    dependencies = {
      "vim-denops/denops.vim",
    },
  },
  {
    "vhyrro/luarocks.nvim",
    config = function() require("luarocks").setup {} end,
  },
  {
    "rest-nvim/rest.nvim",
    ft = "http",
    event = "VeryLazy",
    dependencies = { "luarocks.nvim" },
    config = function() require("rest-nvim").setup {} end,
  },
  { "dccsillag/magma-nvim", run = ":UpdateRemotePlugins" },
}
