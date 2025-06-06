return {
  "gelguy/wilder.nvim",
  config = function()
    -- config goes here
    -- vim.cmd "UpdateRemotePlugins"
    require("wilder").setup { modes = { ":", "/", "?" } }
    require("wilder").set_option("pipeline", {
      require("wilder").branch(
        require("wilder").cmdline_pipeline {
          -- sets the language to use, 'vim' and 'python' are supported
          language = "python",
          -- 0 turns off fuzzy matching
          -- 1 turns on fuzzy matching
          -- 2 partial fuzzy matching (match does not have to begin with the same first letter)
          fuzzy = 1,
        },
        require("wilder").python_search_pipeline {
          -- can be set to wilder#python_fuzzy_delimiter_pattern() for stricter fuzzy matching
          pattern = require("wilder").python_fuzzy_pattern(),
          -- omit to get results in the order they appear in the buffer
          sorter = require("wilder").python_difflib_sorter(),
          -- can be set to 're2' for performance, requires pyre2 to be installed
          -- see :h wilder#python_search() for more details
          engine = "re",
        }
      ),
    })
  end,
}
