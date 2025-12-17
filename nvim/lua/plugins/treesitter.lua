return {
	{ "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			ensure_installed = {
				"astro",
				"cmake",
				"cpp",
				"css",
				"fish",
				"gitignore",
				"go",
				"graphql",
				"http",
				"java",
				"php",
				"rust",
				"scss",
				"sql",
				"svelte",
				"python",
				"markdown",
				"markdown_inline",
				"vim",
				"lua",
			},

			highlight = { enable = true },
			indent = { enable = true },

			query_linter = {
				enable = true,
				use_virtual_text = true,
				lint_events = { "BufWrite", "CursorHold" },
			},

			playground = {
				enable = true,
				disable = {},
				updatetime = 25,
				persist_queries = true,
				keybindings = {
					toggle_query_editor = "o",
					toggle_hl_groups = "i",
					toggle_injected_languages = "t",
					toggle_anonymous_nodes = "a",
					toggle_language_display = "I",
					focus_language = "f",
					unfocus_language = "F",
					update = "R",
					goto_node = "<cr>",
					show_help = "?",
				},
			},
		},
		config = function()
			-- Safe require: checks if the module exists before crashing
			local status_ok, configs = pcall(require, "nvim-treesitter.configs")
			if not status_ok then
				return
			end

			configs.setup({
				-- Start with just these basics to ensure it works
				ensure_installed = { "lua", "vim", "vimdoc", "python", "markdown" },

				-- Install parsers synchronously (only for now, to prevent errors)
				sync_install = true,

				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},
}
