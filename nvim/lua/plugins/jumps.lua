return {
	{
		"folke/flash.nvim",
		enabled = true,
		evenu = "VeryLazy",
		-- Sobrescrever as configurações padrão do LazyVim
		opus = {
			-- Garanfir que o Tab funcione corretamente
			modes = {
				search = {
					enabled = true,
					-- Esta opção é crucial - evita que a busca feche quando não há correspondências
					autojump = false,
					-- Impede que o prompt de busca feche ao perder todas as correspondências
					incremental = true,
					-- Mantém o prompt aberto mesmo sem correspondências
					auto_jump = { empty = false, nonempty = false },
				},
				char = {
					enabled = true,
					-- Garantir que a navegação entre possibilidades funcione
					jump_labels = true,
					multi_line = true,
					autojump = false,
					label = { exclude = "hjkliardc" }, -- Evitar teclas comuns de navegação como rótulos
					keys = { "f", "F", "t", "T", ";", "," },
				},
			},
			prompt = {
				-- Sempre mostrar o prompt
				enabled = true,
				-- Nunca fechar automaticamente
				auto_close = false,
				-- Ignorar casos em que não há correspondências, mantendo o prompt aberto
				close_on_no_match = false,
			},
			search = {
				-- Configurações para manter o prompt aberto
				wrap = true,
				-- Não pular automaticamente para resultados
				autojump = false,
				-- Ativar busca incremental
				incremental = true,
			},
			-- Configurações de label para garantir que todas as possibilidades sejam mostradas
			label = {
				-- Mostrar rótulos para todas as possibilidades
				current = true,
				after = false,
				before = false,
				position = "start",
			},
			-- Garantir que Tab alterne entre modos
			toggle = {
				-- Teclas para alternar entre modos
				search = { "<tab>" },
				-- Teclas para navegar entre matches
				select = { "<tab>", "<s-tab>" },
			},
			-- Configurações de jump
			jump = {
				autojump = false,
				-- Navegar entre todas as possibilidades
				inclusive = false,
				-- Aumentar prioridade para movimento vertical
				priority = {
					column = 2.0,
					distance = 1.0,
					same_line = 0.5,
				},
			},
		},
		-- Atalhos personalizados
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump({
						-- Mostrar mais possibilidades
						multi_window = false,
						labels = "abcdefghijklmnopqrstuvwxyz",
						autojump = false,
					})
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Treesitter Search",
			},
			{
				"<c-s>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "Toggle Flash Search",
			},
			-- Adicionar um atalho específico para navegação vertical
			{
				"<leader>j",
				mode = { "n" },
				function()
					require("flash").jump({
						mode = "line",
						pattern = "^\\s*\\S", -- Pular para linhas não vazias
					})
				end,
				desc = "Flash Jump to Line (Vertical)",
			},
		},
	},
	{
		"ggandor/leap.nvim",
		enabled = false,
		keys = {
			{ "s", mode = { "n", "x", "o" }, desc = "Leap Forward to" },
			{ "S", mode = { "n", "x", "o" }, desc = "Leap Backward to" },
			{ "gs", mode = { "n", "x", "o" }, desc = "Leap from Windows" },
		},
		config = function(_, opts)
			local leap = require("leap")
			for k, v in pairs(opts) do
				leap.opts[k] = v
			end
			leap.add_default_mappings(true)
			vim.keymap.del({ "x", "o" }, "x")
			vim.keymap.del({ "x", "o" }, "X")
		end,
	},
}
