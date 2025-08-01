return {
  {
    "smoka7/hop.nvim",
    version = "*",
    enabled = true,
    opts = {
      keys = "etovxqpdygfblzhckisuran",
      jump_on_sole_occurrence = false, -- Não pular automaticamente quando há apenas uma ocorrência
      case_insensitive = true, -- Busca não diferencia maiúsculas/minúsculas
      create_hl_autocmd = true, -- Cria highlights automaticamente
      uppercase_labels = true, -- Mostra labels em maiúsculas
      multi_windows = false, -- Não usar em múltiplas janelas por padrão
    },
    keys = {
      -- Atalhos básicos
      { "<leader>hw", "<cmd>HopWord<cr>", desc = "Hop Word" },
      { "<leader>hl", "<cmd>HopLine<cr>", desc = "Hop Line" },
      { "<leader>hc", "<cmd>HopChar1<cr>", desc = "Hop 1-Char" },
      { "<leader>h2", "<cmd>HopChar2<cr>", desc = "Hop 2-Char" },
      { "<leader>hp", "<cmd>HopPattern<cr>", desc = "Hop Pattern" },

      -- Atalhos alternativos (você pode personalizar conforme sua preferência)
      { "fw", "<cmd>HopWord<cr>", desc = "Hop Word" },
      { "fl", "<cmd>HopLine<cr>", desc = "Hop Line" },
      { "fc", "<cmd>HopChar1<cr>", desc = "Hop 1-Char" },
      { "f2", "<cmd>HopChar2<cr>", desc = "Hop 2-Char" },
      { "f/", "<cmd>HopPattern<cr>", desc = "Hop Pattern" },

      -- Integração com operadores
      { "fw", "<cmd>HopWord<cr>", mode = { "o" }, desc = "Hop Word" },
      { "fl", "<cmd>HopLine<cr>", mode = { "o" }, desc = "Hop Line" },
      { "fc", "<cmd>HopChar1<cr>", mode = { "o" }, desc = "Hop 1-Char" },

      -- Atalhos para navegação vertical (semelhante ao que você tinha no flash.nvim)
      { "<leader>j", "<cmd>HopLine<cr>", desc = "Hop Line (Vertical Navigation)" },

      -- Atalhos para janelas e áreas específicas
      {
        "<leader>hw",
        function()
          require("hop").hint_words({ current_line_only = false })
        end,
        desc = "Hop Words (All)",
      },

      {
        "<leader>hh",
        function()
          require("hop").hint_lines_skip_whitespace()
        end,
        desc = "Hop Lines (Skip Whitespace)",
      },

      -- Modo visual
      { "fw", "<cmd>HopWord<cr>", mode = { "v" }, desc = "Hop Word" },
      { "fl", "<cmd>HopLine<cr>", mode = { "v" }, desc = "Hop Line" },
    },
    config = function(_, opts)
      local hop = require("hop")
      hop.setup(opts)

      -- Opcionalmente, definir highlights personalizados
      vim.api.nvim_set_hl(0, "HopNextKey", { fg = "#ff007c", bold = true })
      vim.api.nvim_set_hl(0, "HopNextKey1", { fg = "#00dfff", bold = true })
      vim.api.nvim_set_hl(0, "HopNextKey2", { fg = "#2b8db3", bold = true })
    end,
  },
  {
    "folke/flash.nvim",
    enabled = true,
    evenu = "VeryLazy",
    -- Sobrescrever as configurações padrão do LazyVim
    opus = {
      -- Garanfir que o Tab funcione corretamente
      modes = {
        search = {
          enabled = true,
          -- Esta opção é crucial - evita que a busca feche quando não há correspondências
          autojump = false,
          -- Impede que o prompt de busca feche ao perder todas as correspondências
          incremental = true,
          -- Mantém o prompt aberto mesmo sem correspondências
          auto_jump = { empty = false, nonempty = false },
        },
        char = {
          enabled = true,
          -- Garantir que a navegação entre possibilidades funcione
          jump_labels = true,
          multi_line = true,
          autojump = false,
          label = { exclude = "hjkliardc" }, -- Evitar teclas comuns de navegação como rótulos
          keys = { "f", "F", "t", "T", ";", "," },
        },
      },
      prompt = {
        -- Sempre mostrar o prompt
        enabled = true,
        -- Nunca fechar automaticamente
        auto_close = false,
        -- Ignorar casos em que não há correspondências, mantendo o prompt aberto
        close_on_no_match = false,
      },
      search = {
        -- Configurações para manter o prompt aberto
        wrap = true,
        -- Não pular automaticamente para resultados
        autojump = false,
        -- Ativar busca incremental
        incremental = true,
      },
      -- Configurações de label para garantir que todas as possibilidades sejam mostradas
      label = {
        -- Mostrar rótulos para todas as possibilidades
        current = true,
        after = false,
        before = false,
        position = "start",
      },
      -- Garantir que Tab alterne entre modos
      toggle = {
        -- Teclas para alternar entre modos
        search = { "<tab>" },
        -- Teclas para navegar entre matches
        select = { "<tab>", "<s-tab>" },
      },
      -- Configurações de jump
      jump = {
        autojump = false,
        -- Navegar entre todas as possibilidades
        inclusive = false,
        -- Aumentar prioridade para movimento vertical
        priority = {
          column = 2.0,
          distance = 1.0,
          same_line = 0.5,
        },
      },
    },
    -- Atalhos personalizados
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump({
            -- Mostrar mais possibilidades
            multi_window = false,
            labels = "abcdefghijklmnopqrstuvwxyz",
            autojump = false,
          })
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
      -- Adicionar um atalho específico para navegação vertical
      {
        "<leader>j",
        mode = { "n" },
        function()
          require("flash").jump({
            mode = "line",
            pattern = "^\\s*\\S", -- Pular para linhas não vazias
          })
        end,
        desc = "Flash Jump to Line (Vertical)",
      },
    },
  },
  {
    "ggandor/leap.nvim",
    enabled = false,
    keys = {
      { "s", mode = { "n", "x", "o" }, desc = "Leap Forward to" },
      { "S", mode = { "n", "x", "o" }, desc = "Leap Backward to" },
      { "gs", mode = { "n", "x", "o" }, desc = "Leap from Windows" },
    },
    config = function(_, opts)
      local leap = require("leap")
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
      leap.add_default_mappings(true)
      vim.keymap.del({ "x", "o" }, "x")
      vim.keymap.del({ "x", "o" }, "X")
    end,
  },
}
