local function augroup(name)
	return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*",
	command = "set nopaste",
})

vim.api.nvim_create_autocmd("LspAttach", {
	once = true,
	callback = function()
		vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#000000", bg = "#b28500" })
	end,
})

-- close some filetypes with <esc>
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("close_with_q"),
	pattern = {
		"PlenaryTestPopup",
		"grug-far",
		"help",
		"lspinfo",
		"notify",
		"qf",
		"spectre_panel",
		"startuptime",
		"tsplayground",
		"neotest-output",
		"checkhealth",
		"neotest-summary",
		"neotest-output-panel",
		"dbout",
		"gitsigns-blame",
		"Lazy",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.schedule(function()
			vim.keymap.set("n", "<esc>", function()
				vim.cmd("close")
				pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
			end, {
				buffer = event.buf,
				silent = true,
				desc = "Quit buffer",
			})
		end)
	end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("wrap_spell"),
	pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
	callback = function()
		-- -- By default wrap is set to true regardless of what I chose in my options.lua file,
		-- -- This sets wrapping for my skitty-notes and I don't want to have
		-- -- wrapping there, I wanto to decide this in the options.lua file
		-- vim.opt_local.wrap = false
		vim.opt_local.spell = true
	end,
})

vim.api.nvim_create_autocmd("CursorHold", {
	group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
	callback = function()
		local mode = vim.api.nvim_get_mode().mode
		if mode ~= "n" then
			return
		end
		-- Only show if there are diagnostics on the current line
		local line = vim.api.nvim_win_get_cursor(0)[1] - 1
		local diagnostics = vim.diagnostic.get(0, { lnum = line })
		if #diagnostics > 0 then
			vim.diagnostic.open_float(nil, {
				focus = false,
				border = "rounded",
				scope = "cursor",
			})
		end
	end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = ".env.*",
	command = "set filetype=sh",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = ".env",
	command = "set filetype=sh",
})

