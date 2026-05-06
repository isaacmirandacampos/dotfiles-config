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
local i = ls.insert_node
local f = ls.function_node

local function clipboard()
  return vim.fn.getreg("+")
end

-- Helper function to create code block snippets
local function create_code_block_snippet(lang)
  return s({
    trig = lang,
    name = "Codeblock",
    desc = lang .. " codeblock",
  }, {
    t({ "```" .. lang, "" }),
    i(1),
    t({ "", "```" }),
  })
end

local languages = {
  "txt", "lua", "sql", "go", "regex", "bash", "markdown", "markdown_inline",
  "yaml", "json", "jsonc", "cpp", "csv", "java", "javascript", "python",
  "dockerfile", "html", "css", "templ", "php",
}

local snippets = {}

for _, lang in ipairs(languages) do
  table.insert(snippets, create_code_block_snippet(lang))
end

table.insert(snippets, s({
  trig = "chirpy",
  name = "Disable markdownlint and prettier for chirpy",
  desc = "Disable markdownlint and prettier for chirpy",
}, {
  t({
    " ",
    "<!-- markdownlint-disable -->",
    "<!-- prettier-ignore-start -->",
    " ",
    "<!-- tip=green, info=blue, warning=yellow, danger=red -->",
    " ",
    "> ",
  }),
  i(1),
  t({ "", "{: .prompt-" }),
  i(2),
  t({
    " }",
    " ",
    "<!-- prettier-ignore-end -->",
    "<!-- markdownlint-restore -->",
  }),
}))

table.insert(snippets, s({
  trig = "markdownlint",
  name = "Add markdownlint disable and restore headings",
  desc = "Add markdownlint disable and restore headings",
}, {
  t({ " ", "<!-- markdownlint-disable -->", " ", "> " }),
  i(1),
  t({ " ", " ", "<!-- markdownlint-restore -->" }),
}))

table.insert(snippets, s({
  trig = "prettierignore",
  name = "Add prettier ignore start and end headings",
  desc = "Add prettier ignore start and end headings",
}, {
  t({ " ", "<!-- prettier-ignore-start -->", " ", "> " }),
  i(1),
  t({ " ", " ", "<!-- prettier-ignore-end -->" }),
}))

table.insert(snippets, s({
  trig = "linkt",
  name = 'Add this -> [](){:target="_blank"}',
  desc = 'Add this -> [](){:target="_blank"}',
}, {
  t("["), i(1), t("]("), i(2), t('){:target="_blank"}'),
}))

table.insert(snippets, s({
  trig = "todo",
  name = "Add TODO: item",
  desc = "Add TODO: item",
}, {
  t("<!-- TODO: "), i(1), t(" -->"),
}))

table.insert(snippets, s({
  trig = "linkc",
  name = "Paste clipboard as .md link",
  desc = "Paste clipboard as .md link",
}, {
  t("["), i(1), t("]("), f(clipboard, {}), t(")"),
}))

table.insert(snippets, s({
  trig = "linkex",
  name = "Paste clipboard as EXT .md link",
  desc = "Paste clipboard as EXT .md link",
}, {
  t("["), i(1), t("]("), f(clipboard, {}), t('){:target="_blank"}'),
}))

table.insert(snippets, s({
  trig = "dotfileslatest",
  name = "Adds -> [my dotfiles](https://github.com/linkarzu/dotfiles-latest)",
  desc = "Add link to https://github.com/linkarzu/dotfiles-latest",
}, {
  t("[my dotfiles](https://github.com/linkarzu/dotfiles-latest)"),
}))

table.insert(snippets, s({
  trig = "newline",
  name = "Adds a blank line in markdown file",
  desc = "Adds a blank line in markdown file",
}, {
  t('<div style="page-break-after: always; visibility: hidden"> pagebreak </div>'),
}))

table.insert(snippets, s({
  trig = "pagebreak",
  name = "Adds a blank line in markdown file",
  desc = "Adds a blank line in markdown file",
}, {
  t('<div style="page-break-after: always; visibility: hidden"> pagebreak </div>'),
}))

table.insert(snippets, s({
  trig = "supportme",
  name = "Inserts links (Ko-fi, Twitter, TikTok)",
  desc = "Inserts links (Ko-fi, Twitter, TikTok)",
}, {
  t({
    "Join discord for free -> https://discord.gg/NgqMgwwtMH",
    "If you want to support me by becoming a YouTube member",
    "https://www.youtube.com/channel/UCrSIvbFncPSlK6AdwE2QboA/join",
    "☕ Support me -> https://ko-fi.com/linkarzu",
    "☑ My Twitter -> https://x.com/link_arzu",
    "❤‍🔥 My tiktok -> https://www.tiktok.com/@linkarzu",
    "My dotfiles (remember to star them) -> https://github.com/linkarzu/dotfiles-latest",
    "A link to my resume -> https://resume.linkarzu.com/",
  }),
}))

table.insert(snippets, s({
  trig = "discord",
  name = "discord support",
  desc = "discord support",
}, {
  t({
    "```txt",
    "I have a members only discord, it's goal is to troubleshoot stuff related to my videos, and try to help users out",
    "If you want to join, the link can be found below",
    "https://www.youtube.com/channel/UCrSIvbFncPSlK6AdwE2QboA/join",
    "```",
  }),
}))

table.insert(snippets, s({
  trig = "bashex",
  name = "Basic bash script example",
  desc = "Simple bash script template",
}, {
  t({
    "```bash",
    "#!/bin/bash",
    "",
    "echo 'helix'",
    "echo 'deeznuts'",
    "```",
    "",
  }),
}))

table.insert(snippets, s({
  trig = "pythonex",
  name = "Basic Python script example",
  desc = "Simple Python script template",
}, {
  t({
    "```python",
    "#!/usr/bin/env python3",
    "",
    "def main():",
    "    print('helix dizpython')",
    "",
    "if __name__ == '__main__':",
    "    main()",
    "```",
    "",
  }),
}))

ls.add_snippets("markdown", snippets)
