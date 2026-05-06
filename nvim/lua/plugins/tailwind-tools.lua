return {
	"luckasRanarison/tailwind-tools.nvim",
	name = "tailwind-tools",
	build = ":UpdateRemotePlugins",
	ft = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte", "astro", "templ" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {},
}
