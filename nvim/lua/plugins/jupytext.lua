return {
	"goerz/jupytext.vim",
	config = function()
		-- This tells Neovim to treat .ipynb files as python files using the "percent" format
		vim.g.jupytext_fmt = "py:percent"
	end,
}
