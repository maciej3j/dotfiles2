-- Colorscheme. LazyVim defaults to tokyonight.
--
-- To switch, uncomment one variant below and set it in the LazyVim opts:
--   { "LazyVim/LazyVim", opts = { colorscheme = "catppuccin" } }
--
-- Colorschemes used before the LazyVim migration (from the old vim.pack config):
--   gruvbox.nvim, kanagawa.nvim, catppuccin, rose-pine, oxocarbon, techbase
return {
  {
    "folke/tokyonight.nvim",
    opts = { style = "night" },
  },

  -- { "ellisonleao/gruvbox.nvim", opts = {} },
  -- { "rebelot/kanagawa.nvim", opts = {} },
  -- { "catppuccin/nvim", name = "catppuccin", opts = {} },
  -- { "rose-pine/neovim", name = "rose-pine", opts = {} },
  -- { "nyoom-engineering/oxocarbon.nvim", opts = {} },
  -- { "mcauley-penney/techbase.nvim", opts = {} },
}
