local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader><leader>", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>sG", function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end, { desc = "Telescope grep string" })
vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Telescope git files" })
vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "Telescope buffers" })

-- telescope projects
require("telescope").load_extension("project")
vim.keymap.set("n", "<leader>pp", function()
	require("telescope").extensions.project.project({})
end, { desc = "Projects" })
