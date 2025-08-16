return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	ft = "markdown",
	build = function()
		vim.fn["mkdp#util#install"]()
	end,
	keys = {
		{
			"<leader>mp",
			ft = "markdown",
			"<cmd>MarkdownPreview<cr>",
			desc = "Markdown Preview",
		},
	},
	init = function()
		-- The default filename is 「${name}」and I just hate those symbols
		vim.g.mkdp_page_title = "${name}"
	end,
}
