return {
  -- Add the community repository of plugin specifications
  "AstroNvim/astrocommunity",
  -- example of importing a plugin, comment out to use it or add your own
  -- available plugins can be found at https://github.com/AstroNvim/astrocommunity

  -- { import = "astrocommunity.colorscheme.catppuccin" },
  { import = "astrocommunity.debugging" },
  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.pack.go" },
  { import = "astrocommunity.pack.scala" },
  -- { import = "astrocommunity.pack.java" },
  -- {
  --   "mfussenegger/nvim-jdtls",
  --   opts = {
  --     settings = {
  --       java = {
  --         configuration = {
  --           runtimes = {
  --             {
  --               name = "JavaSE-11",
  --               path = "$HOME/.sdkman/candidates/java/11.0.23-zulu/",
  --             },
  --           },
  --         },
  --       },
  --     },
  --   },
  -- },
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.sql" },
  { import = "astrocommunity.completion.cmp-cmdline" },
  { import = "astrocommunity.completion.copilot-lua-cmp" },
  { import = "astrocommunity.editing-support.todo-comments-nvim" },
  { import = "astrocommunity.remote-development.distant-nvim" },
  { import = "astrocommunity.code-runner.compiler-nvim" },
  { import = "astrocommunity.test.neotest" },
  -- { import = "astrocommunity.colorscheme.lua/astrocommunity/colorscheme/tokyonight-nvim" },
  { import = "astrocommunity.search.nvim-hlslens" },
  { import = "astrocommunity.git.git-blame-nvim" },
  -- { import = "astrocommunity.lsp" },
}
