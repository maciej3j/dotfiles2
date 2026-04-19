vim.keymap.set("n", "<leader>E", function()
	Snacks.explorer.open({
		cwd = vim.fn.stdpath("config"), -- ~/.config/nvim
		hidden = true, -- jeśli chcesz ukryte pliki
	})
end, { desc = "Explorer: Neovim Config" })
vim.keymap.set("n", "<leader>e", function()
	Snacks.explorer.open({ hidden = true })
end, { desc = "Reveal File in Explorer" })

vim.keymap.set("t", "<c-/>", function()
	Snacks.terminal()
end, { desc = "Toggle Terminal" })
vim.keymap.set("t", "<c-_>", function()
	Snacks.terminal()
end, { desc = "Toggle Terminal" })
