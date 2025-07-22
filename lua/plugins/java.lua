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
      -- 项目根目录标识符
      root_markers = {
        ".git",
        "mvnw",
        "gradlew",
        "pom.xml",
        "build.gradle",
        "build.gradle.kts",
        ".project",
        "settings.gradle",
        "settings.gradle.kts",
      },

      -- JDK 配置
      jdk = {
        auto_install = false, -- 使用系统已安装的 Java 21
      },

      -- 通知配置
      notifications = {
        dap = true, -- DAP 调试通知
      },

      -- Spring Boot 支持
      spring_boot_tools = {
        enable = true,
      },

      -- JVM 参数优化
      jvm_args = function()
        local args = {
          -- 为 Java 21 优化内存设置
          "-Xmx2G",
          "-XX:+UseG1GC",
          "-XX:+UseStringDeduplication",
          -- 支持预览功能（如果需要）
          "--enable-preview",
          -- 添加 JVM 参数以避免警告
          "--add-opens",
          "java.base/java.util=ALL-UNNAMED",
          "--add-opens",
          "java.base/java.lang=ALL-UNNAMED",
          "--add-opens",
          "java.base/java.nio.file=ALL-UNNAMED",
          "--add-opens",
          "java.base/sun.nio.ch=ALL-UNNAMED",
        }

        -- 如果 lombok.jar 存在，添加 Lombok 支持
        local lombok_paths = {
          vim.fn.expand "~/.local/share/nvim/mason/packages/lombok-nightly/lombok.jar",
          vim.fn.expand "~/.local/share/nvim/mason/share/jdtls/lombok.jar",
          vim.fn.expand "~/.local/share/nvim/mason/packages/jdtls/lombok.jar",
        }

        for _, lombok_jar in ipairs(lombok_paths) do
          if vim.fn.filereadable(lombok_jar) == 1 then
            table.insert(args, "-javaagent:" .. lombok_jar)
            break
          end
        end

        return args
      end,
    }

    -- JDTLS 配置优化
    require("lspconfig").jdtls.setup {
      settings = {
        java = {
          -- Java 21 特定配置
          configuration = {
            runtimes = {
              {
                name = "JavaSE-21",
                path = "/home/arc/.sdkman/candidates/java/current",
                default = true,
              },
              -- 兼容性配置
              {
                name = "JavaSE-17",
                path = "/home/arc/.sdkman/candidates/java/current",
              },
              {
                name = "JavaSE-11",
                path = "/home/arc/.sdkman/candidates/java/current",
              },
            },
            -- Maven 设置
            maven = {
              downloadSources = true,
              downloadJavadoc = true,
            },
            -- 更新项目设置
            updateBuildConfiguration = "automatic",
          },

          -- 编译设置
          compile = {
            nullAnalysis = {
              mode = "interactive",
            },
          },

          -- 代码生成设置
          codeGeneration = {
            toString = {
              template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
            hashCodeEquals = {
              useJava7Objects = true,
            },
            useBlocks = true,
          },

          -- 完成设置
          completion = {
            favoriteStaticMembers = {
              "org.hamcrest.MatcherAssert.assertThat",
              "org.hamcrest.Matchers.*",
              "org.hamcrest.CoreMatchers.*",
              "org.junit.jupiter.api.Assertions.*",
              "java.util.Objects.requireNonNull",
              "java.util.Objects.requireNonNullElse",
              "org.mockito.Mockito.*",
            },
            importOrder = {
              "java",
              "javax",
              "com",
              "org",
            },
            filteredTypes = {
              "com.sun.*",
              "io.micrometer.shaded.*",
            },
          },

          -- 内容辅助
          contentProvider = {
            preferred = "fernflower",
          },

          -- Eclipse 设置
          eclipse = {
            downloadSources = true,
          },

          -- 格式化设置
          format = {
            enabled = true,
            settings = {
              url = vim.fn.stdpath "config" .. "/formatter/eclipse-java-google-style.xml",
              profile = "GoogleStyle",
            },
          },

          -- 导入设置
          saveActions = {
            organizeImports = true,
          },

          -- 项目设置
          project = {
            sourcePaths = {},
            referencedLibraries = {},
          },

          -- 重构设置
          sources = {
            organizeImports = {
              starThreshold = 9999,
              staticStarThreshold = 9999,
            },
          },

          -- 签名帮助
          signatureHelp = {
            enabled = true,
          },

          -- 实现 CodeLens
          implementationsCodeLens = {
            enabled = true,
          },

          -- 引用 CodeLens
          referencesCodeLens = {
            enabled = true,
          },
        },
      },

      -- 初始化选项
      init_options = {
        bundles = {},
        workspaceFolders = vim.fn.has "nvim-0.8" == 1 and vim.lsp.buf.list_workspace_folders() or nil,
      },

      -- 能力设置
      capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), {
        textDocument = {
          completion = {
            completionItem = {
              snippetSupport = true,
            },
          },
        },
      }),

      -- 处理器设置
      handlers = {
        ["language/status"] = function(_, result)
          -- 自定义状态处理
        end,
        ["$/progress"] = function(_, result, ctx)
          -- 自定义进度处理
        end,
      },
    }
  end,
}
