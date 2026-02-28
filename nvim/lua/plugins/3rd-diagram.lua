return {
	{
		"3rd/diagram.nvim",
		dependencies = {
			"3rd/image.nvim",
		},
		opts = {
			events = {
				render_buffer = { "BufWinEnter", "BufWritePost", "TextChanged", "TextChangedI" },
				clear_buffer = { "BufLeave" },
			},
			renderer_options = {
				mermaid = {
					background = "transparent",
					theme = "dark",
					scale = 3,
				},
			},
		},
	},
}
