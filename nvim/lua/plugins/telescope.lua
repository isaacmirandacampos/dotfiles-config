
-- return {
-- 	"nvim-telescope/telescope.nvim",
-- 	dependencies = {
-- 		{
-- 			"nvim-telescope/telescope-fzf-native.nvim",
-- 			build = "make",
-- 		},
-- 		"nvim-telescope/telescope-file-browser.nvim",
-- 	},
-- 	keys = {
-- 		-- Sobrescrever o keymap padrão do LazyVim para <leader>ff
-- 		{
-- 			"<leader>ff",
-- 			function()
-- 				require("telescope.builtin").find_files({
-- 					hidden = true,
-- 					no_ignore = false, -- Respeita os globs configurados
-- 				})
-- 			end,
-- 			desc = "Find Files (com arquivos ocultos)",
-- 		},
-- 		-- Alternativa: buscar TODOS os arquivos incluindo ignorados
-- 		{
-- 			"<leader>fF",
-- 			function()
-- 				require("telescope.builtin").find_files({
-- 					hidden = true,
-- 					no_ignore = true, -- Mostra TUDO
-- 				})
-- 			end,
-- 			desc = "Find ALL Files (incluindo ignorados)",
-- 		},
-- 		{
-- 			"<leader>fP",
-- 			function()
-- 				require("telescope.builtin").find_files({
-- 					cwd = require("lazy.core.config").options.root,
-- 				})
-- 			end,
-- 			desc = "Find Plugin File",
-- 		},
-- 		{
-- 			";f",
-- 			function()
-- 				local builtin = require("telescope.builtin")
-- 				builtin.find_files({
-- 					no_ignore = false,
-- 					hidden = true,
-- 				})
-- 			end,
-- 			desc = "Lists files in your current working directory, respects .gitignore",
-- 		},
-- 		{
-- 			";r",
-- 			function()
-- 				local builtin = require("telescope.builtin")
-- 				builtin.live_grep({
-- 					additional_args = { "--hidden" },
-- 				})
-- 			end,
-- 			desc = "Search for a string in your current working directory and get results live as you type, respects .gitignore",
-- 		},
-- 		{
-- 			"\\\\",
-- 			function()
-- 				local builtin = require("telescope.builtin")
-- 				builtin.buffers()
-- 			end,
-- 			desc = "Lists open buffers",
-- 		},
-- 		{
-- 			";t",
-- 			function()
-- 				local builtin = require("telescope.builtin")
-- 				builtin.help_tags()
-- 			end,
-- 			desc = "Lists available help tags and opens a new window with the relevant help info on <cr>",
-- 		},
-- 		{
-- 			";;",
-- 			function()
-- 				local builtin = require("telescope.builtin")
-- 				builtin.resume()
-- 			end,
-- 			desc = "Resume the previous telescope picker",
-- 		},
-- 		{
-- 			";e",
-- 			function()
-- 				local builtin = require("telescope.builtin")
-- 				builtin.diagnostics()
-- 			end,
-- 			desc = "Lists Diagnostics for all open buffers or a specific buffer",
-- 		},
-- 		{
-- 			";s",
-- 			function()
-- 				local builtin = require("telescope.builtin")
-- 				builtin.treesitter()
-- 			end,
-- 			desc = "Lists Function names, variables, from Treesitter",
-- 		},
-- 		{
-- 			";c",
-- 			function()
-- 				local builtin = require("telescope.builtin")
-- 				builtin.lsp_incoming_calls()
-- 			end,
-- 			desc = "Lists LSP incoming calls for word under the cursor",
-- 		},
-- 		{
-- 			"sf",
-- 			function()
-- 				local telescope = require("telescope")

-- 				local function telescope_buffer_dir()
-- 					return vim.fn.expand("%:p:h")
-- 				end

-- 				telescope.extensions.file_browser.file_browser({
-- 					path = "%:p:h",
-- 					cwd = telescope_buffer_dir(),
-- 					respect_gitignore = false,
-- 					hidden = true,
-- 					grouped = true,
-- 					previewer = false,
-- 					initial_mode = "normal",
-- 					layout_config = { height = 40 },
-- 				})
-- 			end,
-- 			desc = "Open File Browser with the path of the current buffer",
-- 		},
-- 	},
-- 	config = function(_, opts)
-- 		local telescope = require("telescope")
-- 		local actions = require("telescope.actions")
-- 		local fb_actions = require("telescope").extensions.file_browser.actions

-- 		-- Mesclar configurações defaults corretamente
-- 		opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
-- 			wrap_results = true,
-- 			layout_strategy = "horizontal",
-- 			layout_config = { prompt_position = "top" },
-- 			sorting_strategy = "ascending",
-- 			winblend = 0,
-- 			-- Configurações de vimgrep
-- 			vimgrep_arguments = {
-- 				"rg",
-- 				"--color=never",
-- 				"--no-heading",
-- 				"--with-filename",
-- 				"--line-number",
-- 				"--column",
-- 				"--smart-case",
-- 				"--hidden",
-- 				"--glob", "!.git/*",
-- 				"--glob", "!node_modules/*",
-- 				"--glob", "!.venv/*",
-- 				"--glob", "!venv/*",
-- 				"--glob", "!__pycache__/*",
-- 				"--glob", "!*.pyc",
-- 				"--glob", "!dist/*",
-- 				"--glob", "!build/*",
-- 				"--glob", "!*.lock",
-- 				"--glob", "!package-lock.json",
-- 			},
-- 			file_ignore_patterns = {
-- 				"^node_modules/",
-- 				"^.venv/",
-- 				"^venv/",
-- 				"^__pycache__/",
-- 				"%.pyc$",
-- 				"^.git/",
-- 				"^dist/",
-- 				"^build/",
-- 				"^target/",
-- 				"%.class$",
-- 				"%.cache$",
-- 				"%.ico$",
-- 				"%.pdf$",
-- 				"%.dylib$",
-- 				"%.jar$",
-- 				"%.docx$",
-- 				"%.met$",
-- 				"smalljre_*",
-- 				".vale/",
-- 				"%.burp$",
-- 				"%.mp4$",
-- 				"%.mkv$",
-- 				"%.rar$",
-- 				"%.zip$",
-- 				"%.7z$",
-- 				"%.tar$",
-- 				"%.bz2$",
-- 				"%.epub$",
-- 				"%.flac$",
-- 				"%.tar.gz$",
-- 			},
-- 			mappings = {
-- 				n = {},
-- 			},
-- 		})

-- 		-- Configurações dos pickers
-- 		opts.pickers = vim.tbl_deep_extend("force", opts.pickers or {}, {
-- 			find_files = {
-- 				hidden = true,
-- 				-- Usar fd se disponível (mais rápido)
-- 				find_command = vim.fn.executable("fd") == 1 
-- 					and {
-- 						"fd",
-- 						"--type", "f",
-- 						"--hidden",
-- 						"--follow",
-- 						"--exclude", ".git",
-- 						"--exclude", "node_modules",
-- 						"--exclude", ".venv",
-- 						"--exclude", "venv",
-- 						"--exclude", "__pycache__",
-- 						"--exclude", "dist",
-- 						"--exclude", "build",
-- 					}
-- 					or {
-- 						"rg",
-- 						"--files",
-- 						"--hidden",
-- 						"--glob", "!.git/*",
-- 						"--glob", "!node_modules/*",
-- 						"--glob", "!.venv/*",
-- 						"--glob", "!venv/*",
-- 						"--glob", "!__pycache__/*",
-- 						"--glob", "!dist/*",
-- 						"--glob", "!build/*",
-- 					},
-- 			},
-- 			diagnostics = {
-- 				theme = "ivy",
-- 				initial_mode = "normal",
-- 				layout_config = {
-- 					preview_cutoff = 9999,
-- 				},
-- 			},
-- 		})

-- 		-- Configurações das extensões
-- 		opts.extensions = {
-- 			file_browser = {
-- 				theme = "dropdown",
-- 				hijack_netrw = true,
-- 				mappings = {
-- 					["n"] = {
-- 						["N"] = fb_actions.create,
-- 						["h"] = fb_actions.goto_parent_dir,
-- 						["/"] = function()
-- 							vim.cmd("startinsert")
-- 						end,
-- 						["<C-u>"] = function(prompt_bufnr)
-- 							for i = 1, 10 do
-- 								actions.move_selection_previous(prompt_bufnr)
-- 							end
-- 						end,
-- 						["<C-d>"] = function(prompt_bufnr)
-- 							for i = 1, 10 do
-- 								actions.move_selection_next(prompt_bufnr)
-- 							end
-- 						end,
-- 						["<PageUp>"] = actions.preview_scrolling_up,
-- 						["<PageDown>"] = actions.preview_scrolling_down,
-- 					},
-- 				},
-- 			},
-- 			fzf = {
-- 				fuzzy = true,
-- 				override_generic_sorter = true,
-- 				override_file_sorter = true,
-- 				case_mode = "smart_case",
-- 			},
-- 		}

-- 		telescope.setup(opts)
-- 		require("telescope").load_extension("fzf")
-- 		require("telescope").load_extension("file_browser")
-- 	end,
-- }

return {
	"nvim-telescope/telescope.nvim",
	-- IMPORTANTE: Para ver arquivos .env, use <leader>ff ou ;f
	-- O arquivo .env geralmente está no .gitignore, então precisamos usar --no-ignore-vcs
	dependencies = {
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
		"nvim-telescope/telescope-file-browser.nvim",
	},
	keys = {
		{
			"<leader>ff",
			function()
				require("telescope.builtin").find_files({
					hidden = true,
					no_ignore = false,
					no_ignore_parent = false,
					find_command = vim.fn.executable("fd") == 1 
						and {
							"fd",
							"--type", "f",
							"--hidden",
							"--follow",
							"--no-ignore-vcs",
							"--exclude", ".git",
							"--exclude", "node_modules",
							"--exclude", ".venv",
							"--exclude", "venv",
							"--exclude", "__pycache__",
							"--exclude", "dist",
							"--exclude", "build",
						}
						or {
							"rg",
							"--files",
							"--hidden",
							"--no-ignore-vcs",
							"--glob", "!.git/*",
							"--glob", "!node_modules/*",
							"--glob", "!.venv/*",
							"--glob", "!venv/*",
							"--glob", "!__pycache__/*",
							"--glob", "!dist/*",
							"--glob", "!build/*",
						},
				})
			end,
			desc = "Find Files (com .env e arquivos ocultos)",
		},
		{
			"<leader>fe",
			function()
				require("telescope.builtin").find_files({
					hidden = true,
					find_command = vim.fn.executable("fd") == 1 
						and {
							"fd",
							"--type", "f", 
							"--hidden",
							"--follow",
							"--exclude", ".git",
							"--exclude", "node_modules",
							"--exclude", ".venv",
							"--exclude", "venv",
							"--exclude", "__pycache__",
							"--exclude", "dist",
							"--exclude", "build",
							"--no-ignore-vcs",
						}
						or {
							"rg",
							"--files",
							"--hidden",
							"--no-ignore",
							"--glob", "!.git/*",
							"--glob", "!node_modules/*",
							"--glob", "!.venv/*",
							"--glob", "!venv/*",
							"--glob", "!__pycache__/*",
							"--glob", "!dist/*",
							"--glob", "!build/*",
						},
				})
			end,
			desc = "Find Files (incluindo .env)",
		},
		{
			"<leader>fF",
			function()
				require("telescope.builtin").find_files({
					hidden = true,
					no_ignore = true,
				})
			end,
			desc = "Find ALL Files (incluindo ignorados)",
		},
		{
			"<leader>fP",
			function()
				require("telescope.builtin").find_files({
					cwd = require("lazy.core.config").options.root,
				})
			end,
			desc = "Find Plugin File",
		},
		{
			";f",
			function()
				local builtin = require("telescope.builtin")
				builtin.find_files({
					no_ignore = false,
					hidden = true,
					find_command = vim.fn.executable("fd") == 1 
						and {
							"fd",
							"--type", "f",
							"--hidden",
							"--follow",
							"--no-ignore-vcs",
							"--exclude", ".git",
							"--exclude", "node_modules",
							"--exclude", ".venv",
							"--exclude", "venv",
							"--exclude", "__pycache__",
							"--exclude", "dist",
							"--exclude", "build",
						}
						or {
							"rg",
							"--files",
							"--hidden",
							"--no-ignore-vcs",
							"--glob", "!.git/*",
							"--glob", "!node_modules/*",
							"--glob", "!.venv/*",
							"--glob", "!venv/*",
							"--glob", "!__pycache__/*",
							"--glob", "!dist/*",
							"--glob", "!build/*",
						},
				})
			end,
			desc = "Lists files in your current working directory, shows .env files",
		},
		{
			";r",
			function()
				local builtin = require("telescope.builtin")
				builtin.live_grep({
					additional_args = { "--hidden" },
				})
			end,
			desc = "Search for a string in your current working directory and get results live as you type, respects .gitignore",
		},
		{
			"\\\\",
			function()
				local builtin = require("telescope.builtin")
				builtin.buffers()
			end,
			desc = "Lists open buffers",
		},
		{
			";t",
			function()
				local builtin = require("telescope.builtin")
				builtin.help_tags()
			end,
			desc = "Lists available help tags and opens a new window with the relevant help info on <cr>",
		},
		{
			";;",
			function()
				local builtin = require("telescope.builtin")
				builtin.resume()
			end,
			desc = "Resume the previous telescope picker",
		},
		{
			";e",
			function()
				local builtin = require("telescope.builtin")
				builtin.diagnostics()
			end,
			desc = "Lists Diagnostics for all open buffers or a specific buffer",
		},
		{
			";s",
			function()
				local builtin = require("telescope.builtin")
				builtin.treesitter()
			end,
			desc = "Lists Function names, variables, from Treesitter",
		},
		{
			";c",
			function()
				local builtin = require("telescope.builtin")
				builtin.lsp_incoming_calls()
			end,
			desc = "Lists LSP incoming calls for word under the cursor",
		},
		{
			"sf",
			function()
				local telescope = require("telescope")

				local function telescope_buffer_dir()
					return vim.fn.expand("%:p:h")
				end

				telescope.extensions.file_browser.file_browser({
					path = "%:p:h",
					cwd = telescope_buffer_dir(),
					respect_gitignore = false,
					hidden = true,
					grouped = true,
					previewer = false,
					initial_mode = "normal",
					layout_config = { height = 40 },
				})
			end,
			desc = "Open File Browser with the path of the current buffer",
		},
	},
	config = function(_, opts)
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local fb_actions = require("telescope").extensions.file_browser.actions

		-- Mesclar configurações defaults corretamente
		opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
			wrap_results = true,
			layout_strategy = "horizontal",
			layout_config = { prompt_position = "top" },
			sorting_strategy = "ascending",
			winblend = 0,
			-- Configurações de vimgrep
			vimgrep_arguments = {
				"rg",
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--smart-case",
				"--hidden",
				"--glob", "!.git/*",
				"--glob", "!node_modules/*",
				"--glob", "!.venv/*",
				"--glob", "!venv/*",
				"--glob", "!__pycache__/*",
				"--glob", "!*.pyc",
				"--glob", "!dist/*",
				"--glob", "!build/*",
				"--glob", "!*.lock",
				"--glob", "!package-lock.json",
			},
			file_ignore_patterns = {
				"^node_modules/",
				"^.venv/",
				"^venv/",
				"^__pycache__/",
				"%.pyc$",
				"^.git/",
				"^dist/",
				"^build/",
				"^target/",
				"%.class$",
				"%.cache$",
				"%.ico$",
				"%.pdf$",
				"%.dylib$",
				"%.jar$",
				"%.docx$",
				"%.met$",
				"smalljre_*",
				".vale/",
				"%.burp$",
				"%.mp4$",
				"%.mkv$",
				"%.rar$",
				"%.zip$",
				"%.7z$",
				"%.tar$",
				"%.bz2$",
				"%.epub$",
				"%.flac$",
				"%.tar.gz$",
				-- NÃO incluir .env aqui para garantir que seja mostrado
			},
			mappings = {
				n = {},
			},
		})

		-- Configurações dos pickers
		opts.pickers = vim.tbl_deep_extend("force", opts.pickers or {}, {
			find_files = {
				hidden = true,
				-- Usar fd se disponível (mais rápido)
				find_command = vim.fn.executable("fd") == 1 
					and {
						"fd",
						"--type", "f",
						"--hidden",
						"--follow",
						"--no-ignore-vcs", -- Não respeita .gitignore
						"--exclude", ".git",
						"--exclude", "node_modules",
						"--exclude", ".venv",
						"--exclude", "venv",
						"--exclude", "__pycache__",
						"--exclude", "dist",
						"--exclude", "build",
					}
					or {
						"rg",
						"--files",
						"--hidden",
						"--no-ignore-vcs", -- Não respeita .gitignore
						"--glob", "!.git/*",
						"--glob", "!node_modules/*",
						"--glob", "!.venv/*",
						"--glob", "!venv/*",
						"--glob", "!__pycache__/*",
						"--glob", "!dist/*",
						"--glob", "!build/*",
					},
			},
			diagnostics = {
				theme = "ivy",
				initial_mode = "normal",
				layout_config = {
					preview_cutoff = 9999,
				},
			},
		})

		-- Configurações das extensões
		opts.extensions = {
			file_browser = {
				theme = "dropdown",
				hijack_netrw = true,
				mappings = {
					["n"] = {
						["N"] = fb_actions.create,
						["h"] = fb_actions.goto_parent_dir,
						["/"] = function()
							vim.cmd("startinsert")
						end,
						["<C-u>"] = function(prompt_bufnr)
							for i = 1, 10 do
								actions.move_selection_previous(prompt_bufnr)
							end
						end,
						["<C-d>"] = function(prompt_bufnr)
							for i = 1, 10 do
								actions.move_selection_next(prompt_bufnr)
							end
						end,
						["<PageUp>"] = actions.preview_scrolling_up,
						["<PageDown>"] = actions.preview_scrolling_down,
					},
				},
			},
			fzf = {
				fuzzy = true,
				override_generic_sorter = true,
				override_file_sorter = true,
				case_mode = "smart_case",
			},
		}

		telescope.setup(opts)
		require("telescope").load_extension("fzf")
		require("telescope").load_extension("file_browser")
	end,
}