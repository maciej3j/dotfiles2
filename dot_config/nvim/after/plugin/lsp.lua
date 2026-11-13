require("lsp_signature").setup({
	bind = true,
	handler_opts = { border = "rounded" },
	hint_prefix = { above = "↙ ", current = "← ", below = "↖ " },
	floating_window_above_cur_line = true,
	close_timeout = 4000,
	hi_parameter = "LspSignatureActiveParameter",
	toggle_key = "<C-k>",
	select_signature_key = "<M-n>",
})

local capabilities = require("blink.cmp").get_lsp_capabilities()

vim.lsp.config("*", { capabilities = capabilities })

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
			telemetry = { enable = false },
		},
	},
})

vim.lsp.config("ty", {
	cmd = { "ty", "server" },
})
vim.lsp.enable("ty")

require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "bashls", "ruff" },
	automatic_enable = { exclude = { "ty" } },
})
