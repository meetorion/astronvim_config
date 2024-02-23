return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "zbirenbaum/copilot-cmp",
    name = "copilot_cmp",
    dependencies = { "zbirenbaum/copilot.lua", opts = {} },
    opts = {},
  },
  opts = function(_, opts) table.insert(opts.sources, { name = "copilot" }) end,
}
