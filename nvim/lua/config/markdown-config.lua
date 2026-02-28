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

		-- Função para calcular path relativo
		local function relative_path(from_file, to_file)
			-- Remove o nome do arquivo de from_file para obter o diretório
			local from_dir = vim.fn.fnamemodify(from_file, ":h")

			-- Divide os paths em partes
			local from_parts = vim.split(from_dir, "/", { trimempty = true })
			local to_parts = vim.split(to_file, "/", { trimempty = true })

			-- Remove partes comuns do início
			local common = 0
			for i = 1, math.min(#from_parts, #to_parts) do
				if from_parts[i] == to_parts[i] then
					common = i
				else
					break
				end
			end

			-- Calcula quantos "../" são necessários
			local ups = #from_parts - common
			local relative = {}

			for _ = 1, ups do
				table.insert(relative, "..")
			end

			-- Adiciona as partes restantes do to_file
			for i = common + 1, #to_parts do
				table.insert(relative, to_parts[i])
			end

			-- Se está no mesmo diretório, usa ./
			if #relative == 1 then
				return "./" .. relative[1]
			end

			return table.concat(relative, "/")
		end

		-- Keybinding para inserir link Obsidian (wikilink)
		vim.keymap.set("n", "<leader>ol", function()
			local current_file = vim.api.nvim_buf_get_name(0)
			local git_root = vim.fn.systemlist("git rev-parse --show-toplevel 2>/dev/null")[1]

			local cmd
			local file_list = {}

			if git_root and git_root ~= "" then
				-- Usa git ls-files para respeitar .gitignore
				cmd = string.format("cd %s && git ls-files '*.md' 2>/dev/null", vim.fn.shellescape(git_root))
				local result = vim.fn.system(cmd)

				for file in result:gmatch("[^\n]+") do
					local full_path = git_root .. "/" .. file
					if full_path ~= current_file then
						local basename = vim.fn.fnamemodify(file, ":t:r")
						table.insert(file_list, { display = file, basename = basename })
					end
				end
			else
				-- Fallback para find se não for git repo
				local current_dir = vim.fn.fnamemodify(current_file, ":h")
				cmd = string.format("find %s -name '*.md' 2>/dev/null", vim.fn.shellescape(current_dir))
				local result = vim.fn.system(cmd)

				for file in result:gmatch("[^\n]+") do
					if file ~= current_file then
						local basename = vim.fn.fnamemodify(file, ":t:r")
						table.insert(file_list, { display = file, basename = basename })
					end
				end
			end

			-- Extrai apenas os displays para o seletor
			local displays = {}
			for _, item in ipairs(file_list) do
				table.insert(displays, item.display)
			end

			-- Mostra seletor
			vim.ui.select(displays, {
				prompt = "Selecione arquivo para link Obsidian:",
			}, function(choice)
				if choice then
					-- Encontra o basename correspondente
					local basename
					for _, item in ipairs(file_list) do
						if item.display == choice then
							basename = item.basename
							break
						end
					end

					-- Insere wikilink do Obsidian: [[basename]]
					local wikilink = "[[" .. basename .. "]]"
					vim.api.nvim_put({ wikilink }, "c", true, true)
				end
			end)
		end, { buffer = true, desc = "Inserir link Obsidian (wikilink)" })

		-- Keybinding para inserir link markdown (Ctrl+k)
		vim.keymap.set("n", "<leader>ml", function()
			local current_file = vim.api.nvim_buf_get_name(0)
			local git_root = vim.fn.systemlist("git rev-parse --show-toplevel 2>/dev/null")[1]

			local cmd
			local file_list = {}

			if git_root and git_root ~= "" then
				-- Usa git ls-files para respeitar .gitignore
				cmd = string.format("cd %s && git ls-files '*.md' 2>/dev/null", vim.fn.shellescape(git_root))
				local result = vim.fn.system(cmd)

				for file in result:gmatch("[^\n]+") do
					local full_path = git_root .. "/" .. file
					if full_path ~= current_file then
						-- Calcula path relativo ao arquivo atual
						local rel_path = relative_path(current_file, full_path)
						table.insert(file_list, { display = file, path = rel_path })
					end
				end
			else
				-- Fallback para find se não for git repo
				local current_dir = vim.fn.fnamemodify(current_file, ":h")
				cmd = string.format("find %s -name '*.md' 2>/dev/null", vim.fn.shellescape(current_dir))
				local result = vim.fn.system(cmd)

				for file in result:gmatch("[^\n]+") do
					if file ~= current_file then
						local rel_path = relative_path(current_file, file)
						table.insert(file_list, { display = file, path = rel_path })
					end
				end
			end

			-- Extrai apenas os displays para o seletor
			local displays = {}
			for _, item in ipairs(file_list) do
				table.insert(displays, item.display)
			end

			-- Mostra seletor
			vim.ui.select(displays, {
				prompt = "Selecione arquivo para link:",
			}, function(choice)
				if choice then
					-- Encontra o path relativo correspondente
					local relative_path_result
					for _, item in ipairs(file_list) do
						if item.display == choice then
							relative_path_result = item.path
							break
						end
					end

					-- Extrai nome do arquivo sem extensão para usar como texto do link
					local basename = vim.fn.fnamemodify(choice, ":t:r")
					-- Insere link markdown padrão: [nome](path.md)
					local markdown_link = "[" .. basename .. "](" .. relative_path_result .. ")"
					vim.api.nvim_put({ markdown_link }, "c", true, true)
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
