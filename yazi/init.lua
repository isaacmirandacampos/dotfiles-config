require("full-border"):setup()
-- require("starship"):setup()

require("custom-shell"):setup({
	save_history = true,
	history_file = "default",
})
require("git"):setup()
require("copy-file-contents"):setup({
	clipboard_cmd = "default",
	append_char = "\n",
	notification = true,
})

require("mactag"):setup({
	-- Keys used to add or remove tags
	keys = {
		r = "Red",
		o = "Orange",
		y = "Yellow",
		g = "Green",
		b = "Blue",
		p = "Purple",
	},
	-- Colors used to display tags
	colors = {
		Red = "#ee7b70",
		Orange = "#f5bd5c",
		Yellow = "#fbe764",
		Green = "#91fc87",
		Blue = "#5fa3f8",
		Purple = "#cb88f8",
	},
})

-- You can configure your bookmarks by lua language
local bookmarks = {
	-- Downloads = "~/Downloads/",
	-- Documents = "~/Documents/",
	-- Personal = "~/Documents/personal/",
	-- Beekoff = "~/Documents/beekoff/",
	-- GL = "~/Documents/gl/",
}
local home_path = ya.target_family() == "windows" and os.getenv("USERPROFILE") or os.getenv("HOME")
local path_sep = package.config:sub(1, 1)

table.insert(bookmarks, {
	tag = "Documents",
	path = home_path .. path_sep .. "Dowloads" .. path_sep,
	key = "d",
})

table.insert(bookmarks, {
	tag = "Personal",
	path = home_path .. path_sep .. "workspaces" .. path_sep .. "personal" .. path_sep,
	key = "p",
})

require("yamb"):setup({
	-- Optional, the path ending with path seperator represents folder.
	bookmarks = bookmarks,
	jump_notify = false,
	-- Optional, the cli of fzf.
	cli = "fzf",
	-- Optional, a string used for randomly generating keys, where the preceding characters have higher priority.
	keys = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
	-- Optional, the path of bookmarks
	path = "/Users/jakejing/.config/yazi/plugins/yamb.yazi/bookmarks",
})

function Status:name()
	local h = self._tab.current.hovered
	if not h then
		return ui.Line({})
	end
	local linked = ""
	if h.link_to ~= nil then
		linked = " -> " .. tostring(h.link_to)
	end
	return ui.Line(" " .. h.name .. linked)
end

-- Header name
-- function header_host()
-- 	if ya.target_family() ~= "unix" then
-- 		return ui.Line({})
-- 	end
-- 	return ui.Span(ya.user_name() .. "@yazi" .. ": "):fg("blue")
-- end

-- Header:children_add(header_host, 500, Header.LEFT)
-- -- group of files and username at the bottom
-- function Status_owner()
-- 	local h = cx.active.current.hovered
-- 	if h == nil or ya.target_family() ~= "unix" then
-- 		return ui.Line({})
-- 	end

-- 	return ui.Line({
-- 		ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
-- 		ui.Span(":"),
-- 		ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
-- 		ui.Span(" "),
-- 	})
-- end

-- Status:children_add(Status_owner, 500, Status.RIGHT)

local pref_by_location = require("pref-by-location")
pref_by_location:setup({
	-- Disable this plugin completely.
	-- disabled = false -- true|false (Optional)

	-- Hide "enable" and "disable" notifications.
	-- no_notify = false -- true|false (Optional)

	prefs = { -- (Optional)
		{
			location = ".*/Downloads",
			sort = { "btime", reverse = true, dir_first = true },
			show_hidden = true,
		},

		{
			location = ".*/.config",
			sort = { "alphabetical", reverse = true, dir_first = true },
			show_hidden = true,
		},
	},
})

function Linemode:size_and_btime()
	local time = math.floor(self._file.cha.btime or 0)
	if time == 0 then
		time = ""
	else
		time = os.date("%d/%m %H:%M", time)
	end

	local size = self._file:size()
	return string.format("%s %s", size and ya.readable_size(size) or "-", time)
end
