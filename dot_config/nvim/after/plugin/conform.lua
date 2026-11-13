require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "black" },
		rust = { "rustfmt" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		javascriptreact = { "prettier" },
		htmldjango = { "djlint" },
		html = { "djlint" },
		css = { "prettier" },
		scss = { "prettier" },
	},
	format_on_save = { timeout_ms = 500, lsp_fallback = true },
})
