return {
  "iamcco/markdown-preview.nvim",
  keys = {
    {
      "<leader>mp",
      ft = "markdown",
      "<cmd>MarkdownPreviewToggle<cr>",
      desc = "Markdown Preview",
    },
  },
  init = function()
    -- The default filename is 「${name}」and I just hate those symbols
    vim.g.mkdp_page_title = "${name}"
  end,
}
