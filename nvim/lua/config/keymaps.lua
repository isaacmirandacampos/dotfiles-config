local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Do things without affecting the registers
keymap.set("n", "x", '"_x')
keymap.set("n", "c", '"_c')

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- move buffer
keymap.set("n", "L", ":bNext<CR>")
keymap.set("n", "H", ":bprevious<CR>")

-- close buffer
keymap.set("n", "bw", ":bd<CR>")

-- find word live grep
keymap.set("n", "<Leader>fw", ":Telescope live_grep<CR>")

-- Delete a word backwards
keymap.set("n", "dw", 'vb"_d')

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Disable continuations
keymap.set("n", "<Leader>o", "o<Esc>^Da", opts)
keymap.set("n", "<Leader>O", "O<Esc>^Da", opts)

-- Jumplist
keymap.set("n", "<C-m>", "<C-i>", opts)

-- New tab
keymap.set("n", "te", ":tabedit")
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)

-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)

-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")

-- Resize window
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")

-- Diagnostics
keymap.set("n", "<C-j>", function()
	vim.diagnostic.goto_next()
end, opts)
keymap.set("n", "gd", function()
	require("telescope.builtin").lsp_definitions()
end, opts)
keymap.set("n", "gD", function()
	require("telescope.builtin").lsp_implementations()
end, opts)
keymap.set("n", "gr", function()
	require("telescope.builtin").lsp_references()
end, opts)
keymap.set("n", "gh", function()
	require("telescope.builtin").lsp_document_symbols()
end, opts)
keymap.set("n", "gt", ":lua vim.lsp.buf.hover()<CR>", opts)
