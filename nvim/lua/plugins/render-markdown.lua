return {
	"MeanderingProgrammer/render-markdown.nvim",
	ft = { "markdown", "mdx" },
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

		latex = {
			enabled = true,
			render_modes = false,
			converter = { "utftex" }, -- Tries utftex first, then fallbacks to latex2text
			highlight = "RenderMarkdownMath",
			position = "center", -- Can be 'center', 'above', or 'below'
			top_pad = 0,
			bottom_pad = 0,
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

		render_modes = { "n", "v" },

		max_file_size = 2.0,

		debounce = 200,
	},
}
