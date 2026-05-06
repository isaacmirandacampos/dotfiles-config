return {
  "L3MON4D3/LuaSnip",
  event = "InsertEnter",
  opts = function(_, opts)
    require("snippets.markdown")
    require("snippets.all")
    return opts
  end,
}
