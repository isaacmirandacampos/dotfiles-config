local full_only = require("util.mode").enabled({})
return {
	{
		"dinhhuy258/git.nvim",
		enabled = full_only,
		event = "BufReadPre",
		opts = {
			keymaps = {
				-- Open blame window
				blame = "<Leader>gb",
				-- Open file/folder in git repository
				browse = "<Leader>go",
			},
		},
	},
}
