-- Keymaps para diagram.nvim
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "md" },
	callback = function()
		-- Deleta qualquer keybinding existente em <leader>mm
		pcall(vim.keymap.del, "n", "<leader>mm", { buffer = true })

		vim.keymap.set("n", "<leader>mm", function()
			local current_line = vim.api.nvim_win_get_cursor(0)[1]
			local bufnr = vim.api.nvim_get_current_buf()
			local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

			local start_line, end_line
			for i = current_line, 1, -1 do
				if lines[i]:match("^```mermaid") then
					start_line = i
					break
				end
			end

			if start_line then
				for i = start_line + 1, #lines do
					if lines[i]:match("^```%s*$") then
						end_line = i
						break
					end
				end
			end

			if start_line and end_line then
				local diagram_lines = vim.list_slice(lines, start_line, end_line)
				local tmp_file = vim.fn.tempname() .. ".mmd"

				vim.fn.writefile(diagram_lines, tmp_file)

				vim.fn.jobstart({ "mermaid-preview", tmp_file }, {
					detach = true,
					on_exit = function()
						vim.fn.delete(tmp_file)
					end,
				})

				vim.notify("🎨 Abrindo diagrama em popup...", vim.log.levels.INFO)
			else
				vim.notify("✗ Diagrama mermaid não encontrado", vim.log.levels.WARN)
			end
		end, { buffer = true, desc = "Preview diagrama mermaid em tmux popup" })
	end,
})
