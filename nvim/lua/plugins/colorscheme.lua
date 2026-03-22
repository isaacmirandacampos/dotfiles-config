local theme = require("config.theme")

return {
	-- Tema ativo (carrega com prioridade)
	{
		theme.plugin,
		lazy = false,
		priority = 1000,
		opts = function()
			return theme.opts
		end,
	},

	-- Temas disponíveis (lazy, instalados mas não carregados)
	{ "craftzdog/solarized-osaka.nvim", lazy = true },
	{ "catppuccin/nvim", lazy = true },
	{ "folke/tokyonight.nvim", lazy = true },
	{ "ellisonleao/gruvbox.nvim", lazy = true },
	{ "rebelot/kanagawa.nvim", lazy = true },
	{ "olimorris/onedarkpro.nvim", lazy = true },
}
