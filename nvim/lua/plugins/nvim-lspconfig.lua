return {
	"neovim/nvim-lspconfig",
	opts = {
		---@type table<string, vim.lsp.Config>
		inlay_hints = { enabled = false },
		---@type lspconfig.options
		servers = {
			-- eslint = {
			-- 	root_dir = function(fname)
			-- 		return require("lspconfig.util").root_pattern(
			-- 			"eslint.config.js",
			-- 			".eslintrc.js",
			-- 			".eslintrc.json",
			-- 			"package.json"
			-- 		)(fname)
			-- 	end,
			-- 	settings = {
			-- 		workingDirectory = { mode = "auto" },
			-- 		useFlatConfig = false,
			-- 	},
			-- },
			eslint = {
				settings = {
					-- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
					workingDirectories = { mode = "auto" },
					format = true,
				},
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
