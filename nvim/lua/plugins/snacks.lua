return {
	{
		"folke/snacks.nvim",
		keys = {
			{ "<leader>e", false },
			{ "<leader>E", false },
		},
		opts = {
			scroll = {
				enabled = false,
			},
			picker = {
				enabled = false,
			},
			explorer = {
				enabled = false,
				autoopen = false,
			},
			lazygit = {
				theme = {
					selectedLineBgColor = { bg = "CursorLine" },
				},
				win = {
					width = 0,
					height = 0,
				},
			},
			notifier = {
				enabled = true,
				top_down = false,
			},
			styles = {
				snacks_image = {
					relative = "editor",
					col = -1,
				},
			},
			image = {
				enabled = true,
				doc = {
					inline = false,
					float = true,
					max_width = 180,
					max_height = 140,
				},
				convert = {
					mermaid = function()
						return { "-i", "{src}", "-o", "{file}", "-b", "white", "-t", "default", "-s", "3" }
					end,
				},
			},
			dashboard = {
				preset = {
					keys = {
						{
							icon = " ",
							key = "f",
							desc = "Find File",
							action = ":lua require('fzf-lua').files()",
						},
						{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
						{
							icon = " ",
							key = "g",
							desc = "Find Text",
							action = ":lua require('fzf-lua').live_grep()",
						},
						{
							icon = " ",
							key = "r",
							desc = "Recent Files",
							action = ":lua require('fzf-lua').oldfiles()",
						},
						{
							icon = " ",
							key = "c",
							desc = "Config",
							action = ":lua require('fzf-lua').files({ cwd = vim.fn.stdpath('config') })",
						},
						{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
						{
							icon = "󰒲 ",
							key = "L",
							desc = "Lazy",
							action = ":Lazy",
							enabled = package.loaded.lazy ~= nil,
						},
						{ icon = " ", key = "<esc>", desc = "Quit", action = ":qa" },
					},
					-- Font Name: ANSI Shadow
					-- https://patorjk.com/software/taag
					header = [[


████████╗███████╗ ██████╗██╗  ██╗ ██████╗ ███████╗███████╗███████╗███████╗
╚══██╔══╝██╔════╝██╔════╝██║  ██║██╔═══██╗██╔════╝██╔════╝██╔════╝██╔════╝
   ██║   █████╗  ██║     ███████║██║   ██║█████╗  █████╗  █████╗  █████╗
   ██║   ██╔══╝  ██║     ██╔══██║██║   ██║██╔══╝  ██╔══╝  ██╔══╝  ██╔══╝
   ██║   ███████╗╚██████╗██║  ██║╚██████╔╝██║     ██║     ███████╗███████╗
   ╚═╝   ╚══════╝ ╚═════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝     ╚══════╝╚══════╝


        ]],
				},
			},
		},
	},
}
