-- treesitter.lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.config").setup({
        -- Lista parserów – tylko te, których naprawdę używasz
        ensure_installed = {
          "bash",
          "comment",
          "css",
          "diff",
          "dockerfile",
          "go",
          "groovy",
          "html",
          "http",
          "java",
          "javascript",
          "jsdoc",
          "json",
          "json5",
          "lua",
          "make",
          "markdown",
          "markdown_inline",
          "python",
          "regex",
          "rust",
          "scss",
          "sql",
          "terraform",
          "toml",
          "tsx",
          "typescript",
          "vim",
          "vimdoc",
          "yaml",
          -- Dodaj tutaj kolejne języki jeśli potrzebujesz (np. "heex", "elixir", "typst")
        },

        -- Główne ustawienia
        highlight = {
          enable = true,                    -- WŁĄCZA kolorowanie!
          additional_vim_regex_highlighting = false,
        },

        indent = {
          enable = true,
        },

        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            node_decremental = "<bs>",
          },
        },
      })
    end,
  },

  -- 2. Textobjects (ruchy i selekcja)
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true,
          selection_modes = {
            ["@parameter.outer"] = "v",
            ["@function.outer"] = "V",
            ["@class.outer"] = "<c-v>",
          },
          include_surrounding_whitespace = false,
        },
        move = {
          set_jumps = true,
        },
      })

      -- === Twoje mappingi (poprawione i wyczyszczone) ===

      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")
      local swap = require("nvim-treesitter-textobjects.swap")

      -- Selekcja
      vim.keymap.set({ "x", "o" }, "am", function() select.select_textobject("@function.outer") end, { desc = "Select function outer" })
      vim.keymap.set({ "x", "o" }, "im", function() select.select_textobject("@function.inner") end, { desc = "Select function inner" })
      vim.keymap.set({ "x", "o" }, "ac", function() select.select_textobject("@class.outer") end, { desc = "Select class outer" })
      vim.keymap.set({ "x", "o" }, "ic", function() select.select_textobject("@class.inner") end, { desc = "Select class inner" })

      -- Ruchy
      vim.keymap.set({ "n", "x", "o" }, "]m", function() move.goto_next_start("@function.outer") end)
      vim.keymap.set({ "n", "x", "o" }, "[m", function() move.goto_previous_start("@function.outer") end)
      vim.keymap.set({ "n", "x", "o" }, "]]", function() move.goto_next_start("@class.outer") end)
      vim.keymap.set({ "n", "x", "o" }, "[[", function() move.goto_previous_start("@class.outer") end)

      -- Swap
      vim.keymap.set("n", "<leader>a", function() swap.swap_next("@parameter.inner") end)
      vim.keymap.set("n", "<leader>A", function() swap.swap_previous("@parameter.outer") end)

      -- Powtarzanie ruchów z ; i ,
      local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
      vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
      vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)
    end,
  },
}
