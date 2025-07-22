-- 简化版 Java 配置，如果复杂版本有问题可以用这个
return {
  "nvim-java/nvim-java",
  lazy = false,
  dependencies = {
    "nvim-java/lua-async-await",
    "nvim-java/nvim-java-core",
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
  },
  config = function()
    require("java").setup({
      root_markers = {
        ".git",
        "mvnw",
        "gradlew", 
        "pom.xml",
        "build.gradle",
      },
      jdk = {
        auto_install = false,
      },
    })
    
    require("lspconfig").jdtls.setup({
      settings = {
        java = {
          configuration = {
            runtimes = {
              {
                name = "JavaSE-21",
                path = "/home/arc/.sdkman/candidates/java/current",
                default = true,
              },
            },
          },
          compile = {
            nullAnalysis = {
              mode = "automatic",
            },
          },
          completion = {
            importOrder = {
              "java",
              "javax", 
              "com",
              "org",
            },
          },
          saveActions = {
            organizeImports = true,
          },
        },
      },
    })
  end,
}