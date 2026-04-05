return -- filename
{
  "b0o/incline.nvim",
  dependencies = { require("config.theme").plugin },
  event = "BufReadPre",
  priority = 1200,
  config = function()
    local colors = require("config.theme").colors()
    require("incline").setup({
      highlight = {
        groups = {
          InclineNormal = { guibg = colors.magenta500 or colors.purple, guifg = colors.base04 or colors.bg },
          InclineNormalNC = { guifg = colors.violet500 or colors.comment, guibg = colors.base03 or colors.black },
        },
      },
      window = { margin = { vertical = 0, horizontal = 1 } },
      hide = {
        cursorline = true,
      },
      render = function(props)
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
        if vim.bo[props.buf].modified then
          filename = "[+] " .. filename
        end

        local icon, color = require("nvim-web-devicons").get_icon_color(filename)
        return { { icon, guifg = color }, { " " }, { filename } }
      end,
    })
  end,
}
