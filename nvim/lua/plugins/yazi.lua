return {
	"mikavilpas/yazi.nvim",
	version = "*", -- use the latest stable version
	event = "VeryLazy",
	dependencies = {
		{ "nvim-lua/plenary.nvim", lazy = true },
	},
	keys = {
		-- 👇 in this section, choose your own keymappings!
		{
			"<leader>e",
			mode = { "n", "v" },
			"<cmd>Yazi<cr>",
			desc = "Open yazi at the current file",
		},
		{
			-- Open in the current working directory
			"<leader>E",
			"<cmd>Yazi cwd<cr>",
			desc = "Open the file manager in nvim's working directory",
		},
		{
			"<c-up>",
			"<cmd>Yazi toggle<cr>",
			desc = "Resume the last yazi session",
		},
	},
	---@type YaziConfig | {}
	opts = {
		open_for_directories = true,
		keymaps = {
			show_help = "<f1>",
		},
		open_file_function = function(chosen_file, config, state)
			local ext = chosen_file:match("%.([^%.]+)$")
			if ext and ext:lower() == "pdf" then
				vim.fn.jobstart({ "open", "-a", "Brave Browser", chosen_file })
			else
				require("yazi.openers").open_file(chosen_file)
			end
		end,
	},
	-- 👇 if you use `open_for_directories=true`, this is recommended
	init = function()
		-- mark netrw as loaded so it's not loaded at all.
		--
		-- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
		vim.g.loaded_netrwPlugin = 1
	end,
}
