return {
  "hrsh7th/nvim-cmp",
  ---@param opts cmp.ConfigSchema
  dependencies = {
    "hrsh7th/cmp-emoji",
    {
      "zbirenbaum/copilot-cmp",
      opts = {},
      config = function(_, opts)
        local copilot_cmp = require("copilot_cmp")
        copilot_cmp.setup(opts)
        -- attach cmp source whenever copilot attaches
        -- fixes lazy-loading issues with the copilot cmp source
        LazyVim.lsp.on_attach(function()
          copilot_cmp._on_insert_enter({})
        end, "copilot")
      end,
      {
        "windwp/nvim-autopairs",
        config = function()
          local cmp = require("cmp")
          local cmp_autopairs = require("nvim-autopairs.completion.cmp")

          -- Remove the default behavior
          cmp.event:off("confirm_done", cmp_autopairs.on_confirm_done)

          -- Add your custom filtering logic
          cmp.event:on("confirm_done", function(entry, vim_item)
            if
              vim_item.kind ~= cmp.lsp.CompletionItemKind.Function
              and vim_item.kind ~= cmp.lsp.CompletionItemKind.Method
            then
              return
            end
            cmp_autopairs.on_confirm_done()(entry, vim_item)
          end)
        end,
      },
    },
  },
  opts = function(_, opts)
    local cmp = require("cmp")
    local has_words_before = function()
      unpack = unpack or table.unpack
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end
    opts.mapping = vim.tbl_extend("force", opts.mapping, {
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
          cmp.select_next_item()
        elseif vim.snippet.active({ direction = 1 }) then
          vim.schedule(function()
            vim.snippet.jump(1)
          end)
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif vim.snippet.active({ direction = -1 }) then
          vim.schedule(function()
            vim.snippet.jump(-1)
          end)
        else
          fallback()
        end
      end, { "i", "s" }),
    })

    table.insert(opts.sources, { name = "nvim_lsp", group_index = 1, priority = 1000 })
    table.insert(opts.sources, { name = "luasnip", group_index = 2, priority = 900 })
    table.insert(opts.sources, 3, {
      name = "copilot",
      group_index = 1,
      priority = 100,
    })
    table.insert(opts.sources, { name = "emoji" })
    table.insert(opts.sources, { name = "mini_snippets" })
  end,
}
