require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff_format" },
		rust = { "rustfmt" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		javascriptreact = { "prettier" },
		html = { "prettier" },
		css = { "prettier" },
		scss = { "prettier" },
	},
	format_on_save = { timeout_ms = 500, lsp_fallback = true },
})
