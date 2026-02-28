-- Configuração de wrap para markdown (compatível com Obsidian)
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "md" },
	callback = function()
		-- Soft wrap visual (não adiciona quebras de linha reais)
		vim.wo.wrap = true
		vim.wo.linebreak = true -- Quebra em palavras inteiras
		vim.wo.breakindent = true -- Mantém indentação nas linhas quebradas

		-- Remove linha guia visual (colorcolumn)
		vim.wo.colorcolumn = ""

		-- Desabilita indent guides e scope highlights
		vim.b.miniindentscope_disable = true
		vim.b.snacks_indent_disable = true

		-- Remove hard wrap automático (importante para compatibilidade Obsidian)
		vim.bo.textwidth = 0
		vim.bo.wrapmargin = 0

		-- Habilita autoformat para markdown
		vim.b.autoformat = true

		-- Filtra diagnósticos de wikilinks do Obsidian
		vim.diagnostic.config({
			virtual_text = {
				format = function(diagnostic)
					-- Remove erros de "Ambiguous link" do marksman
					if diagnostic.message and diagnostic.message:match("[Aa]mbiguous") then
						return nil
					end
					return diagnostic.message
				end,
			},
		}, vim.api.nvim_get_current_buf())

		-- Keybinding para inserir link markdown (Ctrl+k)
		vim.keymap.set("n", "<leader>ml", function()
			local current_file = vim.api.nvim_buf_get_name(0)
			local current_dir = vim.fn.fnamemodify(current_file, ":h")

			-- Busca todos os arquivos .md
			local cmd = string.format("find %s -name '*.md' 2>/dev/null", vim.fn.shellescape(current_dir))
			local result = vim.fn.system(cmd)

			local files = {}
			for file in result:gmatch("[^\n]+") do
				if file ~= current_file then -- Exclui o arquivo atual
					local basename = vim.fn.fnamemodify(file, ":t:r")
					table.insert(files, basename)
				end
			end

			-- Mostra seletor
			vim.ui.select(files, {
				prompt = "Selecione arquivo para link:",
			}, function(choice)
				if choice then
					-- Insere wikilink
					vim.api.nvim_put({ "[[" .. choice .. "]]" }, "c", true, true)
				end
			end)
		end, { buffer = true, desc = "Inserir link markdown" })

		-- Keybinding para seguir links markdown/wikilinks (gd)
		vim.keymap.set("n", "gd", function()
			local line = vim.api.nvim_get_current_line()

			-- Tenta extrair wikilink [[Nome do Arquivo]]
			local wikilink = line:match("%[%[([^%]]+)%]%]")
			if wikilink then
				-- Diretório do arquivo atual
				local current_file = vim.api.nvim_buf_get_name(0)
				local current_dir = vim.fn.fnamemodify(current_file, ":h")

				-- Variações do nome do arquivo
				local patterns = {
					wikilink .. ".md",
					wikilink:gsub(" ", "%%20") .. ".md",
					wikilink:gsub(" ", "_") .. ".md",
					wikilink:gsub(" ", "-") .. ".md",
				}

				for _, pattern in ipairs(patterns) do
					-- Busca no diretório atual e subdiretórios
					local cmd = string.format(
						"find %s -name %s 2>/dev/null",
						vim.fn.shellescape(current_dir),
						vim.fn.shellescape(pattern)
					)
					local result = vim.fn.system(cmd)

					if result ~= "" then
						local file = vim.split(result, "\n")[1]
						vim.cmd("edit " .. vim.fn.fnameescape(file))
						return
					end
				end

				vim.notify(
					"Arquivo não encontrado: " .. wikilink .. "\nProcurado em: " .. current_dir,
					vim.log.levels.WARN
				)
				return
			end

			-- Tenta extrair link markdown [texto](caminho.md)
			local markdown_link = line:match("%[.-%]%(([^%)]+)%)")
			if markdown_link then
				-- Decodifica URL encoding
				local path = markdown_link:gsub("%%20", " ")

				-- Se for caminho relativo, resolve a partir do diretório do arquivo atual
				if not path:match("^/") then
					local current_file = vim.api.nvim_buf_get_name(0)
					local current_dir = vim.fn.fnamemodify(current_file, ":h")
					path = current_dir .. "/" .. path
				end

				vim.cmd("edit " .. vim.fn.fnameescape(path))
				return
			end

			-- Fallback para comportamento padrão do gd (LSP)
			vim.lsp.buf.definition()
		end, { buffer = true, desc = "Seguir link markdown/wikilink" })
	end,
})
