require("which-key").setup({})
require("which-key").add({
	{ "<leader>f", group = "Znajdź (Telescope/Snacks)" },
	{ "<leader>g", group = "Idź do (Go to)" },
	{ "<leader>h", group = "Git (Hunks)" },
	{ "<leader>b", group = "Buffery" },
	{ "<leader>s", group = "Okna (Splits)" },
	{ "<leader>d", group = "Diagnostyka" },
	{ "<leader>t", group = "Przełączniki (Toggle)" },
	{ "<leader>c", group = "Kod (LSP)" },
	{ "<leader>x", group = "Trouble (Błędy)" },
	{ "]", group = "Następny" },
	{ "[", group = "Poprzedni" },
})
