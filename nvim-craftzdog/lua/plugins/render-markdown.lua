-- Filename: ~/.config/neovim/neobean/lua/plugins/render-markdown.lua
-- Versão avançada com cores do solarized-osaka

return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "craftzdog/solarized-osaka.nvim" },
  
  init = function()
    -- Carrega as cores do solarized-osaka
    local c = require("solarized-osaka.colors").setup({ transform = true })
    
    -- Função auxiliar para criar tons mais claros/escuros
    local function blend(color1, color2, alpha)
      local r1 = tonumber(color1:sub(2, 3), 16)
      local g1 = tonumber(color1:sub(4, 5), 16)
      local b1 = tonumber(color1:sub(6, 7), 16)
      local r2 = tonumber(color2:sub(2, 3), 16)
      local g2 = tonumber(color2:sub(4, 5), 16)
      local b2 = tonumber(color2:sub(6, 7), 16)
      
      local r = math.floor(r1 * alpha + r2 * (1 - alpha))
      local g = math.floor(g1 * alpha + g2 * (1 - alpha))
      local b = math.floor(b1 * alpha + b2 * (1 - alpha))
      
      return string.format("#%02x%02x%02x", r, g, b)
    end
    
    -- Define um esquema de cores mais suave se preferir
    local heading_colors = {
      h1 = { fg = c.orange, bg = blend(c.orange, c.base03, 0.1) },
      h2 = { fg = c.blue, bg = blend(c.blue, c.base03, 0.1) },
      h3 = { fg = c.green, bg = blend(c.green, c.base03, 0.1) },
      h4 = { fg = c.magenta, bg = blend(c.magenta, c.base03, 0.1) },
      h5 = { fg = c.yellow, bg = blend(c.yellow, c.base03, 0.1) },
      h6 = { fg = c.cyan, bg = blend(c.cyan, c.base03, 0.1) },
    }
    
    -- if vim.g.md_heading_bg == "transparent" then
      -- Background transparente
      vim.cmd(string.format([[highlight Headline1Bg guibg=NONE guifg=%s gui=bold]], heading_colors.h1.fg))
      vim.cmd(string.format([[highlight Headline2Bg guibg=NONE guifg=%s gui=bold]], heading_colors.h2.fg))
      vim.cmd(string.format([[highlight Headline3Bg guibg=NONE guifg=%s gui=bold]], heading_colors.h3.fg))
      vim.cmd(string.format([[highlight Headline4Bg guibg=NONE guifg=%s gui=bold]], heading_colors.h4.fg))
      vim.cmd(string.format([[highlight Headline5Bg guibg=NONE guifg=%s gui=bold]], heading_colors.h5.fg))
      vim.cmd(string.format([[highlight Headline6Bg guibg=NONE guifg=%s gui=bold]], heading_colors.h6.fg))
    -- else
    --   -- Com background sutil
      -- vim.cmd(string.format([[highlight Headline1Bg guifg=%s guibg=%s gui=bold]], c.base3, heading_colors.h1.bg))
      -- vim.cmd(string.format([[highlight Headline2Bg guifg=%s guibg=%s gui=bold]], c.base3, heading_colors.h2.bg))
      -- vim.cmd(string.format([[highlight Headline3Bg guifg=%s guibg=%s gui=bold]], c.base3, heading_colors.h3.bg))
      -- vim.cmd(string.format([[highlight Headline4Bg guifg=%s guibg=%s gui=bold]], c.base3, heading_colors.h4.bg))
      -- vim.cmd(string.format([[highlight Headline5Bg guifg=%s guibg=%s gui=bold]], c.base3, heading_colors.h5.bg))
      -- vim.cmd(string.format([[highlight Headline6Bg guifg=%s guibg=%s gui=bold]], c.base3, heading_colors.h6.bg))
    -- end
    
    -- Ícones dos headings
    vim.cmd(string.format([[highlight Headline1Fg cterm=bold gui=bold guifg=%s]], heading_colors.h1.fg))
    vim.cmd(string.format([[highlight Headline2Fg cterm=bold gui=bold guifg=%s]], heading_colors.h2.fg))
    vim.cmd(string.format([[highlight Headline3Fg cterm=bold gui=bold guifg=%s]], heading_colors.h3.fg))
    vim.cmd(string.format([[highlight Headline4Fg cterm=bold gui=bold guifg=%s]], heading_colors.h4.fg))
    vim.cmd(string.format([[highlight Headline5Fg cterm=bold gui=bold guifg=%s]], heading_colors.h5.fg))
    vim.cmd(string.format([[highlight Headline6Fg cterm=bold gui=bold guifg=%s]], heading_colors.h6.fg))
    
    -- Código inline com fundo sutil
    vim.cmd(string.format([[highlight RenderMarkdownCodeInline guifg=%s guibg=%s]], c.green500, blend(c.base02, c.base03, 0.5)))
    
    -- Checkboxes
    vim.cmd(string.format([[highlight RenderMarkdownUnchecked guifg=%s]], c.base1))
    vim.cmd(string.format([[highlight RenderMarkdownChecked guifg=%s gui=bold]], c.green))
    
    -- Links
    vim.cmd(string.format([[highlight RenderMarkdownLink guifg=%s gui=underline]], c.blue1))
    
    -- Listas
    vim.cmd(string.format([[highlight RenderMarkdownBullet guifg=%s]], c.orange))
    
    -- Tabelas
    vim.cmd(string.format([[highlight RenderMarkdownTableHead guifg=%s gui=bold]], c.purple))
    vim.cmd(string.format([[highlight RenderMarkdownTableRow guifg=%s]], c.base0))
    
    -- Citações (quotes)
    vim.cmd(string.format([[highlight RenderMarkdownQuote guifg=%s]], c.base1))
  end,

  opts = {
    -- Configuração anti-conceal para melhor visibilidade
    anti_conceal = {
      enabled = true,
    },
    
    bullet = {
      enabled = true,
      icons = { "●", "○", "◆", "◇" },
      right_pad = 1,
      left_pad = 0,
    },
    
    checkbox = {
      enabled = true,
      position = "inline",
      unchecked = {
        icon = "󰄱 ",
        highlight = "RenderMarkdownUnchecked",
      },
      checked = {
        icon = "󰱒 ",
        highlight = "RenderMarkdownChecked",
      },
      custom = {
        todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
        important = { raw = "[!]", rendered = "󰀨 ", highlight = "RenderMarkdownImportant" },
      },
    },

    html = {
      enabled = true,
      comment = {
        conceal = false,
      },
    },

    link = {
      enabled = true,
      image = "󰥶 ",
      email = "󰊫 ",
      hyperlink = "󰌹 ",
      custom = {
        github = { pattern = "github%.com", icon = "󰊤 " },
        gitlab = { pattern = "gitlab%.com", icon = "󰮠 " },
        youtube = { pattern = "youtu%.be", icon = "󰗃 " },
        twitter = { pattern = "twitter%.com", icon = "󰕄 " },
      },
    },

    heading = {
      enabled = true,
      sign = false,
      position = "inline",
      icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
      signs = { "󰫎 " },
      width = "full",
      left_pad = 0,
      right_pad = 0,
      min_width = 0,
      border = false,
      border_prefix = false,
      above = "▄",
      below = "▀",
      backgrounds = {
        "Headline1Bg",
        "Headline2Bg",
        "Headline3Bg",
        "Headline4Bg",
        "Headline5Bg",
        "Headline6Bg",
      },
      foregrounds = {
        "Headline1Fg",
        "Headline2Fg",
        "Headline3Fg",
        "Headline4Fg",
        "Headline5Fg",
        "Headline6Fg",
      },
    },
    
    code = {
      enabled = true,
      sign = true,
      style = "full",
      position = "left",
      language_pad = 0,
      disable_background = { "diff" },
      width = "full",
      left_pad = 0,
      right_pad = 0,
      min_width = 0,
      border = "thin",
      above = "▄",
      below = "▀",
      highlight = "RenderMarkdownCode",
      highlight_inline = "RenderMarkdownCodeInline",
    },
    
    dash = {
      enabled = true,
      icon = "─",
      width = "full",
      highlight = "RenderMarkdownDash",
    },
    
    quote = {
      enabled = true,
      icon = "▌",
      repeat_linebreak = false,
      highlight = "RenderMarkdownQuote",
    },
    
    -- Configuração de desempenho
    render_modes = { "n", "v", "i", "c" },
    
    -- Desabilita rendering em arquivos grandes
    max_file_size = 2.0,
    
    -- Debounce para melhor performance
    debounce = 100,
  },
}