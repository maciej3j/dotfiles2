require("rose-pine").setup({ styles = { italic = false }, highlight_groups = { Comment = { italic = true } } })
require("catppuccin").setup({
	flavour = "mocha",
	transparent_background = false,
	styles = { italic = false },
	integrations = {
		blink_cmp = true,
		gitsigns = true,
		lsp_trouble = true,
		mason = true,
		snacks = true,
		treesitter = true,
		which_key = true,
		bufferline = true,
		lualine = true,
	},
})

vim.cmd.colorscheme("tokyonight")
