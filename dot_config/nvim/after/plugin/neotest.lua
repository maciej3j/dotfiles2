local neotest = require("neotest")

neotest.setup({
	adapters = {
		require("neotest-python")({
			pytest = { args = { "--", "-q" } },
		}),
	},
})

local function map(mode, key, fn, desc)
	vim.keymap.set(mode, key, fn, { noremap = true, silent = true, desc = desc })
end

map("n", "<leader>rr", function()
	neotest.run.run()
end, "Uruchom najbliższy test")

map("n", "<leader>rf", function()
	neotest.run.run(vim.fn.expand("%"))
end, "Uruchom testy w pliku")

map("n", "<leader>ra", function()
	neotest.run.run(vim.uv.cwd())
end, "Uruchom wszystkie testy projektu")

map("n", "<leader>rd", function()
	neotest.run.run({ strategy = "dap" })
end, "Debuguj najbliższy test")

map("n", "<leader>ro", function()
	neotest.output.open()
end, "Pokaż output testów")

map("n", "<leader>rs", function()
	neotest.run.stop()
end, "Zatrzymaj testy")
