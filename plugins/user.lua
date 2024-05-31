return {
  -- You can also add new plugins here as well:
  -- Add plugins, the lazy syntax
  -- "andweeb/presence.nvim",
  -- { "github/copilot.vim", event = "VeryLazy" },
  "AstroNvim/astrolsp",
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
  { "sindrets/diffview.nvim", event = "VeryLazy" },
  -- lazy.nvim
  {
    "shuntaka9576/preview-asciidoc.vim",
    -- event = "VeryLazy",
    dependencies = {
      "vim-denops/denops.vim",
    },
  },
  { "dccsillag/magma-nvim", run = ":UpdateRemotePlugins" },
  -- copy from dusk.nvim
  -- The Java LSP server
  -- {
  --   "mfussenegger/nvim-jdtls",
  --   ft = "java",
  --   event = "VeryLazy",
  --   config = function() require "user.pluginconfigs.jdtls" end,
  -- },

  -- Rename packages and imports also when renaming/moving files via nvim-tree (for Java)
  {
    "simaxme/java.nvim",
    ft = "java",
    event = "VeryLazy",
    after = { "mfussenegger/nvim-jdtls" },
    config = function() require("simaxme-java").setup() end,
  },
  {
    "JavaHello/spring-boot.nvim",
    ft = "java",
    dependencies = {
      "mfussenegger/nvim-jdtls", -- or nvim-java, nvim-lspconfig
      "ibhagwan/fzf-lua", -- 可选
    },
  },

  -- Sonarlint plugin
  -- {
  --   "https://gitlab.com/schrieveslaach/sonarlint.nvim",
  --   ft = { "java", "python", "cpp", "typescript", "typescriptreact", "html" },
  --   dependencies = { "mfussenegger/nvim-jdtls" },
  --   opts = {
  --     handlers = {},
  --   },
  --   config = function()
  --     require("sonarlint").setup {
  --       server = {
  --         root_dir = require("jdtls.setup").find_root { "gradlew", ".git", "pom.xml", "mvnw" },
  --         -- autostart = true,
  --         cmd = {
  --           "sonarlint-language-server",
  --           -- Ensure that sonarlint-language-server uses stdio channel
  --           "-stdio",
  --           "-analyzers",
  --           -- paths to the analyzers you need, using those for python and java in this example
  --           vim.fn.expand "$MASON/share/sonarlint-analyzers/sonarpython.jar",
  --           vim.fn.expand "$MASON/share/sonarlint-analyzers/sonarcfamily.jar",
  --           vim.fn.expand "$MASON/share/sonarlint-analyzers/sonarjava.jar",
  --           vim.fn.expand "$MASON/share/sonarlint-analyzers/sonarjs.jar",
  --           vim.fn.expand "$MASON/share/sonarlint-analyzers/sonarhtml.jar",
  --         },
  --         settings = {
  --           sonarlint = {
  --             pathToCompileCommands = vim.fn.getcwd() .. "/compile_commands.json",
  --           },
  --         },
  --       },
  --       filetypes = {
  --         -- Tested and working
  --         "python",
  --         "cpp",
  --         "java",
  --         "typescript",
  --         "html",
  --       },
  --     }
  --   end,
  -- },
  --
  -- DAP (Required to run Java unit tests and Debugging)--
  { "mfussenegger/nvim-dap", ft = "java" },
  {
    "rcarriga/nvim-dap-ui",
    ft = "java",
    dependencies = { "nvim-neotest/nvim-nio" },
    opts = {},
  },
  { "theHamsta/nvim-dap-virtual-text", ft = "java", opts = {} },
}
