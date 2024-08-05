return {
  "olexsmir/gopher.nvim",
  ft = "go",
  build = function()
    if not require("lazy.core.config").spec.plugins["mason.nvim"] then
      vim.print "Installing go dependencies..."
      vim.cmd.GoInstallDeps()
    end
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    { "williamboman/mason.nvim", optional = true }, -- by default use Mason for go dependencies
  },
  opts = {},
}, {
  "nvim-neotest/neotest",
  optional = true,
  dependencies = { "nvim-neotest/neotest-go" },
  opts = function(_, opts)
    if not opts.adapters then opts.adapters = {} end
    table.insert(opts.adapters, require "neotest-go"(require("astrocore").plugin_opts "neotest-go"))
  end,
}, {
  "stevearc/conform.nvim",
  optional = true,
  opts = {
    formatters_by_ft = {
      go = { "goimports", "gofumpt" },
    },
  },
}
