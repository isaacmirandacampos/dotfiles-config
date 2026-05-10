return {
	"goerz/jupytext.vim",
	enabled = require("util.mode").enabled({}),
	ft = "python",
	config = function()
		-- This tells Neovim to treat .ipynb files as python files using the "percent" format
		vim.g.jupytext_fmt = "py:percent"
	end,
}
