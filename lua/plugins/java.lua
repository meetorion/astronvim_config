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
    -- 配置 nvim-java 插件
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

      -- JDTLS 设置（通过 nvim-java 管理）
      jdtls = {
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
                updateSnapshots = true,
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
      },
    }

    -- 设置 LSP 键绑定（改进版，确保 gd 工作）
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("java-lsp-attach", { clear = true }),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == "jdtls" then
          local opts = { buffer = args.buf, silent = true, noremap = true }

          -- 延迟设置键绑定，确保 LSP 完全就绪
          vim.defer_fn(function()
            -- 跳转到定义（改进版）
            vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
            vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)

            -- 跳转到实现
            vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)

            -- 跳转到类型定义
            vim.keymap.set("n", "gy", function() vim.lsp.buf.type_definition() end, opts)

            -- 查找引用
            vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)

            -- 悬停文档
            vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)

            -- 重命名
            vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)

            -- 代码操作
            vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)

            -- 格式化
            vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format { async = true } end, opts)

            -- 诊断
            vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
            vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
            vim.keymap.set("n", "<leader>d", function() vim.diagnostic.open_float() end, opts)
            vim.keymap.set("n", "<leader>q", function() vim.diagnostic.setloclist() end, opts)

            print "Java LSP 键绑定已设置 - gd 可用"
          end, 1000) -- 延迟 1 秒确保 LSP 就绪
        end
      end,
    })
  end,
}
