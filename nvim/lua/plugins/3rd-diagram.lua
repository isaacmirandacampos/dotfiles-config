return {
	{
		"3rd/diagram.nvim",
		enabled = false,
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
					background = "white",
					theme = "default",
					scale = 3,
				},
			},
		},
	},
}
