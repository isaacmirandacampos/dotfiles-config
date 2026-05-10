return {
	"luckasRanarison/tailwind-tools.nvim",
	enabled = require("util.mode").enabled({}),
	name = "tailwind-tools",
	build = ":UpdateRemotePlugins",
	ft = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte", "astro", "templ" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {},
}
