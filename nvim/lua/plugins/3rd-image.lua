return {
	"3rd/image.nvim",
	build = false,
	opts = {
		backend = "kitty",
		processor = "magick_cli",
		-- integrations = {
		-- 	markdown = {
		-- 		enabled = true,
		-- 		clear_in_insert_mode = false,
		-- 		download_remote_images = true,
		-- 		only_render_image_at_cursor = false,
		-- 		filetypes = { "markdown", "vimwiki" },
		-- 		resolve_image_path = function(document_path, image_path, fallback)
		-- 			return fallback(document_path, image_path)
		-- 		end,
		-- 	},
		-- },
		-- max_width = nil,
		-- max_height = nil,
		-- max_width_window_percentage = 100,
		-- max_height_window_percentage = 100,
		-- window_overlap_clear_enabled = false,
		-- window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "scrollview" },
		-- editor_only_render_when_focused = false,
		-- tmux_show_only_in_active_window = true,
		-- hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
		-- kitty_method = "normal",
	},
}
