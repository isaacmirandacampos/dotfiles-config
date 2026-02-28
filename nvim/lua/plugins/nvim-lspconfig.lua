return {
	"neovim/nvim-lspconfig",
	opts = {
		---@type table<string, vim.lsp.Config>
		inlay_hints = { enabled = false },
		---@type lspconfig.options
		servers = {
			eslint = {
				settings = {
					-- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
					workingDirectories = { mode = "auto" },
					format = true,
				},
				root_dir = function(...)
					return require("lspconfig.util").root_pattern(
						".eslintrc",
						".eslintrc.js",
						".eslintrc.cjs",
						".eslintrc.yaml",
						".eslintrc.yml",
						".eslintrc.json",
						"eslint.config.js",
						"eslint.config.mjs",
						"eslint.config.cjs",
						"eslint.config.ts",
						"eslint.config.mts",
						"eslint.config.cts",
						"package.json"
					)(...)
				end,
			},
			harper_ls = {
				enabled = true,
				filetypes = { "markdown" },
				settings = {
					["harper-ls"] = {
						userDictPath = "~/.config/nvim/spell/en.utf-8.add",
						linters = {
							ToDoHyphen = false,
							-- SentenceCapitalization = true,
							-- SpellCheck = true,
						},
						isolateEnglish = true,
						markdown = {
							-- [ignores this part]()
							-- [[ also ignores my marksman links ]]
							IgnoreLinkTitle = true,
						},
					},
				},
			},
			marksman = {
				enabled = false, -- Desabilita marksman para evitar erros com wikilinks do Obsidian
			},
			cssls = {},
			tailwindcss = {
				root_dir = function(...)
					return require("lspconfig.util").root_pattern(".git")(...)
				end,
			},
			tsserver = {
				root_dir = function(...)
					return require("lspconfig.util").root_pattern(".git")(...)
				end,
				single_file_support = false,
				settings = {
					typescript = {
						inlayHints = {
							includeInlayParameterNameHints = "literal",
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = false,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						},
					},
					javascript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						},
					},
				},
			},
			html = {},
			yamlls = {
				settings = {
					yaml = {
						keyOrdering = false,
					},
				},
			},
			lua_ls = {
				-- enabled = false,
				single_file_support = true,
				settings = {
					Lua = {
						workspace = {
							checkThirdParty = false,
						},
						completion = {
							workspaceWord = true,
							callSnippet = "Both",
						},
						misc = {
							parameters = {
								-- "--log-level=trace",
							},
						},
						hint = {
							enable = true,
							setType = false,
							paramType = true,
							paramName = "Disable",
							semicolon = "Disable",
							arrayIndex = "Disable",
						},
						doc = {
							privateName = { "^_" },
						},
						type = {
							castNumberToInteger = true,
						},
						diagnostics = {
							disable = { "incomplete-signature-doc", "trailing-space" },
							-- enable = false,
							groupSeverity = {
								strong = "Warning",
								strict = "Warning",
							},
							groupFileStatus = {
								["ambiguity"] = "Opened",
								["await"] = "Opened",
								["codestyle"] = "None",
								["duplicate"] = "Opened",
								["global"] = "Opened",
								["luadoc"] = "Opened",
								["redefined"] = "Opened",
								["strict"] = "Opened",
								["strong"] = "Opened",
								["type-check"] = "Opened",
								["unbalanced"] = "Opened",
								["unused"] = "Opened",
							},
							unusedLocalExclude = { "_*" },
						},
						format = {
							enable = false,
							defaultConfig = {
								indent_style = "space",
								indent_size = "2",
								continuation_indent_size = "2",
							},
						},
					},
				},
			},
			document_color = {
				enabled = true, -- can be toggled by commands
				kind = "inline", -- "inline" | "foreground" | "background"
				inline_symbol = "󰝤 ", -- only used in inline mode
				debounce = 200, -- in milliseconds, only applied in insert mode
			},
			conceal = {
				enabled = false, -- can be toggled by commands
				min_length = nil, -- only conceal classes exceeding the provided length
				symbol = "󱏿", -- only a single character is allowed
				highlight = { -- extmark highlight options, see :h 'highlight'
					fg = "#38BDF8",
				},
			},
			keymaps = {
				smart_increment = { -- increment tailwindcss units using <C-a> and <C-x>
					enabled = true,
					units = { -- see lua/tailwind/units.lua to see all the defaults
						{
							prefix = "border",
							values = { "2", "4", "6", "8" },
						},
						-- ...
					},
				},
			},
			cmp = {
				highlight = "foreground", -- color preview style, "foreground" | "background"
			},
			telescope = {
				utilities = {
					callback = function(name, class) end, -- callback used when selecting an utility class in telescope
				},
			},
			-- see the extension section to learn more
			extension = {
				queries = {}, -- a list of filetypes having custom `class` queries
				patterns = { -- a map of filetypes to Lua pattern lists
					-- rust = { "class=[\"']([^\"']+)[\"']" },
					-- javascript = { "clsx%(([^)]+)%)" },
				},
			},
		},
		setup = {
			eslint = function()
				local formatter = LazyVim.lsp.formatter({
					name = "eslint: lsp",
					primary = false,
					priority = 200,
					filter = "eslint",
				})

				-- register the formatter with LazyVim
				LazyVim.format.register(formatter)
			end,
		},
	},
}
