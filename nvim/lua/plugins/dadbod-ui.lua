return {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
    { "tpope/vim-dadbod", lazy = true },
    { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
  },
  cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
  keys = {
    { "<leader>D", "<cmd>DBUIToggle<cr>", desc = "Toggle DBUI" },
  },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_save_location = vim.fn.expand("~/workspaces/personal/fragmented/databases/queries")
    vim.g.db_ui_tmp_query_location = vim.fn.expand("~/workspaces/personal/fragmented/databases/queries/tmp")
    vim.g.db_ui_execute_on_save = 0
  end,
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "sql", "mysql", "plsql" },
      callback = function(event)
        vim.keymap.set("n", "<C-CR>", "<Plug>(DBUI_ExecuteQuery)", { buffer = event.buf, desc = "Execute query" })
        vim.keymap.set("v", "<C-CR>", "<Plug>(DBUI_ExecuteQuery)", { buffer = event.buf, desc = "Execute selected query" })
        -- Restore arrow keys in insert mode (sqlcomplete overrides them)
        vim.keymap.set("i", "<Right>", "<Right>", { buffer = event.buf })
        vim.keymap.set("i", "<Left>", "<Left>", { buffer = event.buf })
        vim.keymap.set("i", "<Up>", "<Up>", { buffer = event.buf })
        vim.keymap.set("i", "<Down>", "<Down>", { buffer = event.buf })
      end,
    })
  end,
}
