local ls = require("luasnip")
local extend_decorator = require("luasnip.util.extend_decorator")

local function auto_semicolon(context)
  if type(context) == "string" then
    return { trig = ";" .. context }
  end
  return vim.tbl_extend("keep", { trig = ";" .. context.trig }, context)
end

extend_decorator.register(ls.s, {
  arg_indx = 1,
  extend = function(original)
    return auto_semicolon(original)
  end,
})
local s = extend_decorator.apply(ls.s, {})

local t = ls.text_node

ls.add_snippets("all", {
  s({
    trig = "workflow",
    name = "Add this -> lamw26wmal",
    desc = "Add this -> lamw26wmal",
  }, {
    t("lamw26wmal"),
  }),

  s({
    trig = "lam",
    name = "Add this -> lamw26wmal",
    desc = "Add this -> lamw26wmal",
  }, {
    t("lamw26wmal"),
  }),

  s({
    trig = "mw25",
    name = "Add this -> lamw26wmal",
    desc = "Add this -> lamw26wmal",
  }, {
    t("lamw26wmal"),
  }),
})
