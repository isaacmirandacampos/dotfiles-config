return {
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		keys = {
			-- Files
			{
				"<leader>ff",
				function()
					require("fzf-lua").files({
						fd_opts = "--type f --hidden --follow --no-ignore-vcs"
							.. " --exclude .git --exclude node_modules --exclude .venv"
							.. " --exclude venv --exclude __pycache__ --exclude dist --exclude build"
							.. " --exclude .obsidian",
					})
				end,
				desc = "Find Files (com .env e arquivos ocultos)",
			},
			{
				"<leader>fF",
				function()
					require("fzf-lua").files({
						fd_opts = "--type f --hidden --follow --no-ignore" .. " --exclude .git",
					})
				end,
				desc = "Find ALL Files (incluindo ignorados)",
			},
			{
				"<leader>fP",
				function()
					require("fzf-lua").files({
						cwd = require("lazy.core.config").options.root,
					})
				end,
				desc = "Find Plugin File",
			},
			{
				"<leader><space>",
				function()
					require("fzf-lua").files()
				end,
				desc = "Find Files",
			},
			-- Grep
			{
				"<leader>sg",
				function()
					require("fzf-lua").live_grep({
						rg_opts = "--column --line-number --no-heading --color=always --smart-case"
							.. " --hidden --glob '!.git/*' --glob '!dictionaries/words.txt'",
					})
				end,
				desc = "Grep",
			},
			{
				";r",
				function()
					require("fzf-lua").live_grep({
						rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden"
							.. " --glob '!.git/*'",
					})
				end,
				desc = "Live Grep",
			},
			-- Tasks (incomplete/completed)
			{
				"<leader>tt",
				function()
					require("fzf-lua").grep({
						search = "^\\s*- \\[ \\]",
						no_esc = true,
						rg_opts = "--column --line-number --no-heading --color=always --no-ignore",
					})
				end,
				desc = "Search incomplete tasks",
			},
			{
				"<leader>tc",
				function()
					require("fzf-lua").grep({
						search = "^\\s*- \\[x\\] `done:",
						no_esc = true,
						rg_opts = "--column --line-number --no-heading --color=always --no-ignore",
					})
				end,
				desc = "Search completed tasks",
			},
			-- Buffers
			{
				"\\\\",
				function()
					require("fzf-lua").buffers()
				end,
				desc = "List Buffers",
			},
			{
				"<S-h>",
				function()
					require("fzf-lua").buffers({
						sort_lastused = true,
					})
				end,
				desc = "Buffers (sorted by last used)",
			},
			-- Git
			{
				"<leader>gl",
				function()
					require("fzf-lua").git_commits()
				end,
				desc = "Git Log",
			},
			{
				"<M-b>",
				function()
					require("fzf-lua").git_branches()
				end,
				desc = "Git Branches",
			},
			-- LSP / Diagnostics
			{
				";e",
				function()
					require("fzf-lua").diagnostics_workspace()
				end,
				desc = "Workspace Diagnostics",
			},
			{
				";s",
				function()
					require("fzf-lua").treesitter()
				end,
				desc = "Treesitter Symbols",
			},
			{
				";c",
				function()
					require("fzf-lua").lsp_incoming_calls()
				end,
				desc = "LSP Incoming Calls",
			},
			-- Misc
			{
				";t",
				function()
					require("fzf-lua").help_tags()
				end,
				desc = "Help Tags",
			},
			{
				";;",
				function()
					require("fzf-lua").resume()
				end,
				desc = "Resume Last Picker",
			},
			{
				"<M-k>",
				function()
					require("fzf-lua").keymaps()
				end,
				desc = "Keymaps",
			},
		},
		opts = {
			defaults = {
				formatter = "path.filename_first",
			},
			winopts = {
				height = 0.9,
				width = 0.9,

				row = 0.5,
				col = 0.5,
				border = "rounded",
				preview = { vertical = "right:50%", layout = "horizontal" },
			},
			files = {
				fd_opts = "--type f --hidden --follow"
					.. " --exclude .git --exclude node_modules --exclude .venv"
					.. " --exclude venv --exclude __pycache__ --exclude dist --exclude build"
					.. " --exclude .obsidian",
				-- Combina fd (respeitando .gitignore) + arquivos .env* ignorados pelo git
				cmd = "fd --type f --hidden --follow"
					.. " --exclude .git --exclude node_modules --exclude .venv"
					.. " --exclude venv --exclude __pycache__ --exclude dist --exclude build"
					.. " --exclude .obsidian"
					.. " && fd --type f --hidden --no-ignore-vcs --glob '.env*'"
					.. " --exclude .git",
			},
			grep = {
				rg_glob = true,
				rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden"
					.. " --glob '!.git/*' --glob '!node_modules/*' --glob '!.venv/*'"
					.. " --glob '!__pycache__/*' --glob '!*.lock' --glob '!.obisidian' --glob '!package-lock.json'",
			},
			keymap = {
				builtin = {
					["<C-d>"] = "preview-page-down",
					["<C-u>"] = "preview-page-up",
				},
				fzf = {
					["ctrl-d"] = "preview-page-down",
					["ctrl-u"] = "preview-page-up",
					["esc"] = "abort",
				},
			},
		},
	},
}
