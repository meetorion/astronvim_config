return {
  "nvim-java/nvim-java",
  lazy = false,
  dependencies = {
    "nvim-java/lua-async-await",
    "nvim-java/nvim-java-refactor",
    "nvim-java/nvim-java-core",
    "nvim-java/nvim-java-test",
    "nvim-java/nvim-java-dap",
    "MunifTanjim/nui.nvim",
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-dap",
    {
      "williamboman/mason.nvim",
      opts = {
        registries = {
          "github:nvim-java/mason-registry",
          "github:mason-org/mason-registry",
        },
      },
    },
  },
  config = function()
    require("java").setup {
      root_markers = {
        ".git",
        "mvnw",
        "gradlew",
        "pom.xml",
        "build.gradle",
      },
      jdk = {
        -- Choose whether to install jdk automatically using mason.nvim
        auto_install = false,
      },
    }
    require("lspconfig").jdtls.setup {
      -- lsp settings
    }
  end,
}
