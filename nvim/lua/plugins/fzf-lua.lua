-- Exclusões centralizadas
local excluded_dirs = {
	".git",
	"node_modules",
	"dist",
	"build",
	".next",
	"coverage",
	"venv",
	".venv",
	"__pycache__",
	".cache",
	".obsidian",
}

local excluded_files = {
	"*.pyc",
	"*.lock",
	"package-lock.json",
}

-- Gera flags --glob '!pattern/*' para rg
local function rg_exclude_globs()
	local parts = {}
	for _, dir in ipairs(excluded_dirs) do
		table.insert(parts, " --glob '!" .. dir .. "/*'")
	end
	for _, file in ipairs(excluded_files) do
		table.insert(parts, " --glob '!" .. file .. "'")
	end
	return table.concat(parts)
end

-- Gera flags --exclude para fd
local function fd_excludes()
	local parts = {}
	for _, dir in ipairs(excluded_dirs) do
		table.insert(parts, " --exclude " .. dir)
	end
	for _, file in ipairs(excluded_files) do
		table.insert(parts, " --exclude " .. file)
	end
	return table.concat(parts)
end

local rg_base = "--column --line-number --no-heading --color=always --smart-case --hidden --no-ignore"
local rg_base_no_smart = "--column --line-number --no-heading --color=always --no-ignore"
local fd_base = "--type f --hidden --follow --no-ignore"

local rg_opts = rg_base .. rg_exclude_globs()
local rg_opts_no_smart = rg_base_no_smart .. rg_exclude_globs()
local fd_opts = fd_base .. fd_excludes()

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
					require("fzf-lua").files({ fd_opts = fd_opts })
				end,
				desc = "Find Files (com .env e arquivos ocultos)",
			},
			{
				"<leader>fF",
				function()
					require("fzf-lua").files({
						fd_opts = "--type f --hidden --follow --no-ignore --exclude .git",
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
						rg_opts = rg_opts .. " --glob '!dictionaries/words.txt'",
					})
				end,
				desc = "Grep",
			},
			{
				";r",
				function()
					require("fzf-lua").live_grep({ rg_opts = rg_opts })
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
						rg_opts = rg_opts_no_smart,
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
						rg_opts = rg_opts_no_smart,
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
				fd_opts = fd_opts,
			},
			grep = {
				rg_glob = true,
				rg_opts = rg_opts,
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
