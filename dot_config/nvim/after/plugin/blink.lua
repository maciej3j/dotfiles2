local default_sources = { "lsp", "path", "snippets", "buffer" }
local django_source = nil

if pcall(require, "django") then
	table.insert(default_sources, 2, "django")
	django_source = {
		django = { name = "Django", module = "django.completions.blink", async = true },
	}
end

require("blink.cmp").setup({
	fuzzy = { implementation = "prefer_rust" },
	keymap = {
		preset = "none",
		["<CR>"] = { "accept", "fallback" },
		["<Tab>"] = {
			function(cmp)
				if cmp.snippet_active() then
					return cmp.snippet_forward()
				end
				return cmp.select_next()
			end,
			"fallback",
		},
		["<S-Tab>"] = {
			function(cmp)
				if cmp.snippet_active() then
					return cmp.snippet_backward()
				end
				return cmp.select_prev()
			end,
			"fallback",
		},
		["<Up>"] = { "select_prev", "fallback" },
		["<Down>"] = { "select_next", "fallback" },
		["<C-p>"] = { "select_prev", "fallback" },
		["<C-n>"] = { "select_next", "fallback" },
		["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
		["<C-e>"] = { "hide" },
	},
	cmdline = {
		enabled = true,
		completion = { menu = {
			auto_show = function()
				return vim.fn.getcmdtype() == ":"
			end,
		} },
	},
	appearance = { nerd_font_variant = "mono" },
	completion = {
		keyword = { range = "full" },
		list = { selection = { preselect = true, auto_insert = true } },
		ghost_text = { enabled = true },
		menu = { auto_show = true },
		documentation = { auto_show = true, auto_show_delay_ms = 0 },
	},
	sources = {
		default = default_sources,
		providers = django_source,
	},
	snippets = {
		expand = function(snippet)
			require("luasnip").lsp_expand(snippet)
		end,
	},
})
