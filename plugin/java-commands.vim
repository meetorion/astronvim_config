" Java LSP 修复命令

" 修复 Java 跳转功能
command! JavaFixGoto lua require('java-fix').fix_java_goto()

" 清理 LSP 缓存
command! JavaCleanCache lua require('java-fix').clean_lsp_cache()

" 重建项目索引
command! JavaRebuild lua require('java-fix').rebuild_project()

" 综合修复
command! JavaFix lua require('java-fix').comprehensive_fix()

" 检查键绑定
command! JavaCheckKeys lua require('java-fix').check_keybind()

" LSP 调试信息
command! JavaDebug lua require('lsp-debug').check()

" 重启 Java LSP
command! JavaRestart lua require('lsp-debug').restart_java_lsp()

" 显示帮助
command! JavaHelp echo "Java LSP 命令:\n:JavaFix - 综合修复\n:JavaFixGoto - 修复跳转\n:JavaCleanCache - 清理缓存\n:JavaRebuild - 重建索引\n:JavaRestart - 重启 LSP\n:JavaDebug - 调试信息"