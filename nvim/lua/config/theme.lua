-- Centraliza a definição do tema para todo o Neovim.
-- Para trocar de tema, altere SOMENTE a linha abaixo.

local ACTIVE = "onedark"

-- ┌──────────────────────────────────────────────────────┐
-- │  Registry de temas                                   │
-- │  Cada entrada mapeia as cores para chaves semânticas │
-- │  compatíveis com incline, render-markdown e hsl.     │
-- └──────────────────────────────────────────────────────┘

---@alias ThemeEntry { plugin: string, colorscheme: string, hsluv: string?, opts: table, colors: fun(transform_opts?: table): table }

---@type table<string, ThemeEntry>
local themes = {
	["solarized-osaka"] = {
		plugin = "craftzdog/solarized-osaka.nvim",
		colorscheme = "solarized-osaka",
		hsluv = "solarized-osaka.hsluv",
		opts = { transparent = true },
		colors = function(transform_opts)
			return require("solarized-osaka.colors").setup(transform_opts or {})
		end,
	},

	["catppuccin-mocha"] = {
		plugin = "catppuccin/nvim",
		colorscheme = "catppuccin",
		hsluv = "catppuccin.lib.hsluv",
		opts = {
			flavour = "mocha",
			transparent_background = true,
		},
		colors = function()
			return require("catppuccin.palettes").get_palette("mocha")
		end,
	},

	["catppuccin-latte"] = {
		plugin = "catppuccin/nvim",
		colorscheme = "catppuccin",
		hsluv = "catppuccin.lib.hsluv",
		opts = {
			flavour = "latte",
			transparent_background = true,
		},
		colors = function()
			return require("catppuccin.palettes").get_palette("latte")
		end,
	},

	["tokyonight-night"] = {
		plugin = "folke/tokyonight.nvim",
		colorscheme = "tokyonight-night",
		hsluv = "tokyonight.hsluv",
		opts = { transparent = true },
		colors = function()
			return require("tokyonight.colors").setup({ style = "night" })
		end,
	},
	["tokyonight-storm"] = {
		plugin = "folke/tokyonight.nvim",
		colorscheme = "tokyonight-storm",
		hsluv = "tokyonight.hsluv",
		opts = { transparent = true },
		colors = function()
			return require("tokyonight.colors").setup({ style = "storm" })
		end,
	},

	["gruvbox"] = {
		plugin = "ellisonleao/gruvbox.nvim",
		colorscheme = "gruvbox",
		opts = { transparent_mode = true },
		colors = function()
			return require("gruvbox").palette
		end,
	},

	["kanagawa"] = {
		plugin = "rebelot/kanagawa.nvim",
		colorscheme = "kanagawa",
		opts = { transparent = true, theme = "wave" },
		colors = function()
			local p = require("kanagawa.colors").setup({ theme = "wave" }).palette
			return p
		end,
	},

	["onedark"] = {
		plugin = "olimorris/onedarkpro.nvim",
		colorscheme = "onedark",
		opts = { options = { transparency = true } },
		colors = function()
			return require("onedarkpro.helpers").get_preloaded_colors("onedark")
		end,
	},
}

-- ┌──────────────────────────────────────────────────────┐
-- │  API pública                                         │
-- └──────────────────────────────────────────────────────┘

local M = {}

---@return ThemeEntry
local function current()
	local entry = themes[ACTIVE]
	if not entry then
		error(
			string.format(
				"Tema '%s' não encontrado no registry. Temas disponíveis: %s",
				ACTIVE,
				table.concat(vim.tbl_keys(themes), ", ")
			)
		)
	end
	return entry
end

M.plugin = current().plugin
M.colorscheme = current().colorscheme
M.hsluv_module = current().hsluv
M.opts = current().opts

--- Retorna a tabela de cores normalizada do tema ativo.
---@param transform_opts? table
---@return table
function M.colors(transform_opts)
	return current().colors(transform_opts)
end

return M
