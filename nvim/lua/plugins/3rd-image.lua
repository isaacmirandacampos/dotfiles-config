return {
	"3rd/image.nvim",
	enabled = false,
	opts = {
		backend = "kitty", -- Change this to "ubherzug" if on Linux/X11 without Kitty
		integrations = {
			markdown = {
				enabled = true,
				clear_in_insert_mode = false,
				download_remote_images = true,
				only_render_image_at_cursor = false,
				filetypes = { "markdown", "vimwiki", "quarto" },
			},
			neorg = {
				enabled = true,
				clear_in_insert_mode = false,
				download_remote_images = true,
				only_render_image_at_cursor = false,
				filetypes = { "norg" },
			},
		},
		max_width = 100,
		max_height = 12,
		max_width_window_percentage = math.huge,
		max_height_window_percentage = math.huge,
		window_overlap_clear_enabled = false,
		window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
	},
}
