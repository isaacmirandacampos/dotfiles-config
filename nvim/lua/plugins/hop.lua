return {
	{
		"smoka7/hop.nvim",
		version = "*",
		enabled = true,
		opts = {
			keys = "etovxqpdygfblzhckisuran",
			jump_on_sole_occurrence = false, -- Não pular automaticamente quando há apenas uma ocorrência
			case_insensitive = true, -- Busca não diferencia maiúsculas/minúsculas
			create_hl_autocmd = true, -- Cria highlights automaticamente
			uppercase_labels = true, -- Mostra labels em maiúsculas
			multi_windows = false, -- Não usar em múltiplas janelas por padrão
		},
		keys = {
			{ "fw", "<cmd>HopWord<cr>", desc = "Hop Word" },
			{ "fl", "<cmd>HopLine<cr>", desc = "Hop Line" },
			{ "fc", "<cmd>HopChar1<cr>", desc = "Hop 1-Char" },
			{ "f2", "<cmd>HopChar2<cr>", desc = "Hop 2-Char" },
			{ "f/", "<cmd>HopPattern<cr>", desc = "Hop Pattern" },

			-- Integração com operadores
			{ "fw", "<cmd>HopWord<cr>", mode = { "o" }, desc = "Hop Word" },
			{ "fl", "<cmd>HopLine<cr>", mode = { "o" }, desc = "Hop Line" },
			{ "fc", "<cmd>HopChar1<cr>", mode = { "o" }, desc = "Hop 1-Char" },

			-- Atalhos para navegação vertical (semelhante ao que você tinha no flash.nvim)
			{ "<leader>j", "<cmd>HopLine<cr>", desc = "Hop Line (Vertical Navigation)" },

			-- Modo visual
			{ "fw", "<cmd>HopWord<cr>", mode = { "v" }, desc = "Hop Word" },
			{ "fl", "<cmd>HopLine<cr>", mode = { "v" }, desc = "Hop Line" },
		},
		config = function(_, opts)
			local hop = require("hop")
			hop.setup(opts)

			-- Opcionalmente, definir highlights personalizados
			vim.api.nvim_set_hl(0, "HopNextKey", { fg = "#ff007c", bold = true })
			vim.api.nvim_set_hl(0, "HopNextKey1", { fg = "#00dfff", bold = true })
			vim.api.nvim_set_hl(0, "HopNextKey2", { fg = "#2b8db3", bold = true })
		end,
	},
}
