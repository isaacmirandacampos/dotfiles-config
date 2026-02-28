return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	enabled = false,
	build = ":Copilot auth",
	event = "InsertEnter", -- Mudei de BufReadPost para InsertEnter
	opts = {
		suggestion = {
			enabled = false, -- IMPORTANTE: Desabilite as sugestões inline do copilot
			auto_trigger = false, -- pois o blink.cmp vai gerenciar as sugestões
		},
		panel = { enabled = false },
		filetypes = {
			markdown = true,
			help = true,
			["*"] = true, -- Habilita para todos os tipos de arquivo
		},
	},
}

