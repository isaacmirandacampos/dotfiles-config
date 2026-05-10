local M = {}

--- Returns true if the current neovim_mode is in the allowed list.
--- "full" mode always loads everything.
---@param allowed string[] modes where this plugin should be active (e.g. {"neodb"}, {"neonotes"})
---@return boolean
function M.enabled(allowed)
	local mode = vim.g.neovim_mode or "full"
	if mode == "full" then
		return true
	end
	return vim.tbl_contains(allowed, mode)
end

return M
