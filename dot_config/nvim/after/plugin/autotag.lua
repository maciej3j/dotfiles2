require("nvim-ts-autotag").setup({
	opts = {
		enable_close = true, -- Automatyczne zamykanie: <h1> -> <h1></h1>
		enable_rename = true, -- Równoczesna zmiana tagów otwierającego i zamykającego
		enable_close_on_slash = true, -- Zamykanie przy wpisaniu </
	},
	-- upewnij się, że obsługuje szablony Django
	filetypes = {
		"html",
		"htmldjango",
		"xml",
		"javascriptreact",
		"typescriptreact",
	},
})
