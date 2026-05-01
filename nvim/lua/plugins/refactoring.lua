return {
  {
    "ThePrimeagen/refactoring.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "lewis6991/async.nvim",
    },
    keys = {
      { "<leader>r", "", desc = "+refactor", mode = { "n", "v" } },
      {
        "<leader>rs",
        function() require("refactoring").select_refactor() end,
        mode = "v",
        desc = "Refactor",
      },
      {
        "<leader>ri",
        function()
          return require("refactoring").inline_var()
        end,
        mode = { "n", "v" },
        expr = true,
        desc = "Inline Variable",
      },
      {
        "<leader>rI",
        function()
          return require("refactoring").inline_func()
        end,
        mode = { "n", "v" },
        expr = true,
        desc = "Inline Function",
      },
      {
        "<leader>rf",
        function()
          return require("refactoring").extract_func()
        end,
        mode = "v",
        expr = true,
        desc = "Extract Function",
      },
      {
        "<leader>rF",
        function()
          return require("refactoring").extract_func_to_file()
        end,
        mode = "v",
        expr = true,
        desc = "Extract Function To File",
      },
      {
        "<leader>rx",
        function()
          return require("refactoring").extract_var()
        end,
        mode = "v",
        expr = true,
        desc = "Extract Variable",
      },
      {
        "<leader>rP",
        function()
          require("refactoring").debug.printf({ below = false })
        end,
        desc = "Debug Print",
      },
      {
        "<leader>rp",
        function()
          require("refactoring").debug.print_var({ normal = true })
        end,
        desc = "Debug Print Variable",
      },
      {
        "<leader>rp",
        function()
          require("refactoring").debug.print_var()
        end,
        mode = "v",
        desc = "Debug Print Variable",
      },
      {
        "<leader>rc",
        function()
          require("refactoring").debug.cleanup({})
        end,
        desc = "Debug Cleanup",
      },
    },
    opts = {
      prompt_func_return_type = {
        go = false,
        java = false,
        cpp = false,
        c = false,
        h = false,
        hpp = false,
        cxx = false,
      },
      prompt_func_param_type = {
        go = false,
        java = false,
        cpp = false,
        c = false,
        h = false,
        hpp = false,
        cxx = false,
      },
      printf_statements = {},
      print_var_statements = {},
      show_success_message = true, -- shows a message with information about the refactor on success
      -- i.e. [Refactor] Inlined 3 variable occurrences
    },
    config = function(_, opts)
      require("refactoring").setup(opts)
    end,
  },
}
