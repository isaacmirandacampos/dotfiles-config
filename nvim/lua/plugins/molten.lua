return {
	{
		"benlubas/molten-nvim",
		version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
		build = ":UpdateRemotePlugins",
		dependencies = { "3rd/image.nvim" },
		init = function()
			-- These are example keymaps; adjust to your taste
			vim.g.molten_auto_open_output = true
			vim.g.molten_image_provider = "image.nvim"
			vim.g.molten_output_win_max_height = 20
		end,
		keys = {
			-- BASIC LIFECYCLE
			{ "<leader>pi", ":MoltenInit<CR>", desc = "[P]ython [I]nit" },
			{ "<leader>pr", ":MoltenRestart!<CR>", desc = "[P]ython [R]estart Kernel" },

			-- RUNNING CODE (Normal Mode)
			{ "<leader>pl", ":MoltenEvaluateLine<CR>", desc = "[P]ython run [L]ine", mode = "n" },
			{ "<leader>pc", ":MoltenReevaluateCell<CR>", desc = "[P]ython re-run [C]ell", mode = "n" },
			{ "<leader>po", ":MoltenEvaluateOperator<CR>", desc = "[P]ython run [O]perator", mode = "n" },

			-- RUNNING CODE (Visual Mode)
			-- In visual mode, just selecting text and hitting <leader>p will run it
			{ "<leader>p", ":<C-u>MoltenEvaluateVisual<CR>", desc = "Run Visual Selection", mode = "v" },

			-- UI / OUTPUT MANAGEMENT
			{ "<leader>ph", ":MoltenHideOutput<CR>", desc = "[P]ython [H]ide Output" },
			{ "<leader>ps", ":MoltenShowOutput<CR>", desc = "[P]ython [S]how Output" },
			{ "<leader>pd", ":MoltenDelete<CR>", desc = "[P]ython [D]elete Cell Output" },
		},
	},
}
