return {
  "lambdalisue/suda.vim",
  config = function()
    vim.g.suda_smart_edit = 1 -- 自动检测需要 sudo 权限的文件
  end,
}
