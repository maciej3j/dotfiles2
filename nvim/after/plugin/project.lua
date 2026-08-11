require("project").setup({
	patterns = { ".git", ".github", "package.json", "Cargo.toml", "go.mod", "pyproject.toml", "*.sln", ".nvim.lua" },
	silent_chdir = true,
	scope_chdir = "global",
	snacks = { enabled = true, opts = { sort = "newest", title = "Projekty", layout = "select", show = "paths" } },
})
