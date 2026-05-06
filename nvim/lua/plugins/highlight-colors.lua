return {

	{
		"brenoprata10/nvim-highlight-colors",
		event = "BufReadPre",
		opts = {
			render = "background",
			enable_hex = true,
			enable_short_hex = true,
			enable_rgb = true,
			enable_hsl = true,
			enable_hsl_without_function = false,
			enable_ansi = false,
			enable_var_usage = false,
			enable_tailwind = false,
		},
	},
}
