if vim.loader then
	vim.loader.enable()
end

-- Mode: "full" (default), "neodb", "neonotes"
vim.g.neovim_mode = vim.env.NEOVIM_MODE or "full"

_G.dd = function(...)
	require("util.debug").dump(...)
end
vim.print = _G.dd

require("config.lazy")

local mode = vim.g.neovim_mode
if mode == "full" then
	require("config.diagram-keymaps")
end
if mode == "full" or mode == "neonotes" then
	require("config.markdown-config")
end
