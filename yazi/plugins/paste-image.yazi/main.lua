local get_cwd = ya.sync(function()
	return tostring(cx.active.current.cwd)
end)

return {
	entry = function()
		local cwd = get_cwd()
		local timestamp = os.date("%Y%m%d-%H%M%S")
		local filename = "clipboard-" .. timestamp .. ".png"
		local filepath = cwd .. "/" .. filename

		local status, err = Command("pngpaste"):arg(filepath):spawn():wait()

		if status and status.success then
			ya.notify({
				title = "Paste Image",
				content = "Saved: " .. filename,
				level = "info",
				timeout = 3,
			})
			-- Refresh to show the new file
			ya.manager_emit("reload", {})
		else
			ya.notify({
				title = "Paste Image",
				content = "No image in clipboard or pngpaste not installed",
				level = "error",
				timeout = 3,
			})
		end
	end,
}
