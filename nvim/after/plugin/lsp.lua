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

require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "bashls", "ruff", "ty" },
	automatic_installation = true,
	handlers = {
		function(server_name)
			require("lspconfig")[server_name].setup({
				capabilities = require("blink.cmp").get_lsp_capabilities(),
			})
		end,
		["lua_ls"] = function()
			require("lspconfig").lua_ls.setup({
				capabilities = require("blink.cmp").get_lsp_capabilities(),
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						telemetry = { enable = false },
					},
				},
			})
		end,
	},
})
