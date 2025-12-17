-- return {
-- 	"nvim-lualine/lualine.nvim",
-- 	opts = function(_, opts)
-- 		local LazyVim = require("lazyvim.util")
-- 		opts.sections.lualine_c[4] = {
-- 			LazyVim.lualine.pretty_path({
-- 				length = 0,
-- 				relative = "cwd",
-- 				modified_hl = "MatchParen",
-- 				directory_hl = "",
-- 				filename_hl = "Bold",
-- 				modified_sign = "",
-- 				readonly_icon = " 󰌾 ",
-- 			}),
-- 		}
-- 		table.insert(
-- 			opts.sections.lualine_x,
-- 			2,
-- 			LazyVim.lualine.status(LazyVim.config.icons.kinds.Copilot, function()
-- 				local clients = package.loaded["copilot"] and LazyVim.lsp.get_clients({ name = "copilot", bufnr = 0 })
-- 					or {}
-- 				if #clients > 0 then
-- 					local status = require("copilot.api").status.data.status
-- 					return (status == "InProgress" and "pending") or (status == "Warning" and "error") or "ok"
-- 				end
-- 			end)
-- 		)
-- 	end,
-- }
return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	opts = function()
		return {
			options = {
				theme = "auto",
				globalstatus = true,
				disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch" },
				lualine_c = { "filename" },
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		}
	end,
}
