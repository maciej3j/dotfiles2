local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- Podświetlanie kopiowanego tekstu
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		vim.hl.on_yank({ higroup = "IncSearch", timeout = 200 })
	end,
})

-- Specyficzne ustawienia dla typów plików
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "markdown", "text", "gitcommit" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.spell = true
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = "rust",
	command = "set colorcolumn=100",
})

-- Automatyczny zapis po utracie ostrości okna
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
	group = augroup,
	callback = function()
		if vim.bo.buftype == "" and vim.bo.modifiable then
			vim.cmd("silent! write")
		end
	end,
})
