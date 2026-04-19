return {
	"MagicDuck/grug-far.nvim",
	cmd = "GrugFar",
	keys = {
		-- 1. Normalny search & replace (cały projekt)
		{
			"<leader>sr",
			function()
				require("grug-far").open()
			end,
			desc = "grug-far: Search & Replace",
			mode = { "n", "x" }, -- działa też po zaznaczeniu tekstu
		},

		-- 2. Tylko w aktualnym pliku + transient (znika po zamknięciu)
		{
			"<leader>sR",
			function()
				require("grug-far").open({
					transient = true, -- bufor znika po zamknięciu
					prefills = {
						paths = vim.fn.expand("%"), -- tylko bieżący plik
					},
				})
			end,
			desc = "grug-far: Search & Replace in current file",
			mode = { "n", "x" },
		},
		-- Search tylko w bieżącym pliku (bez transient)
		{
			"<leader>sf",
			function()
				require("grug-far").open({
					prefills = { paths = vim.fn.expand("%") },
				})
			end,
			desc = "grug-far: Search in current file",
		},
	},

	opts = {
		-- transient = false, --tylko w sR
		windowCreationCommand = "botright vsplit",
	},
}
