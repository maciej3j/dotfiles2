local dap = require("dap")
local dapui = require("dapui")

local mason_debugpy = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
local python = vim.fn.filereadable(mason_debugpy) == 1 and mason_debugpy or "python"

require("dap-python").setup(python)

local dap_configs = {
	{
		type = "python",
		request = "launch",
		name = "Django: runserver",
		program = "manage.py",
		args = { "runserver", "--noreload" },
		django = true,
		justMyCode = false,
		cwd = "${workspaceFolder}",
	},
}

dap.configurations.python = vim.list_extend(dap_configs, dap.configurations.python or {})

dapui.setup({
	layouts = {
		{ elements = { "scopes", "breakpoints", "stacks", "watches" }, size = 40, position = "left" },
		{ elements = { "repl", "console" }, size = 12, position = "bottom" },
	},
})

dap.listeners.after.event_initialized["dapui_config"] = dapui.open
dap.listeners.before.event_terminated["dapui_config"] = dapui.close
dap.listeners.before.event_exited["dapui_config"] = dapui.close

local function map(mode, key, fn, desc)
	vim.keymap.set(mode, key, fn, { noremap = true, silent = true, desc = desc })
end

map("n", "<F5>", dap.continue, "Kontynuuj / Rozpocznij debugowanie")
map("n", "<F10>", dap.step_over, "Wykonaj krok (step over)")
map("n", "<F11>", dap.step_into, "Wejdź do funkcji")
map("n", "<F12>", dap.step_out, "Wyjdź z funkcji")
map("n", "<leader>db", dap.toggle_breakpoint, "Przełącz breakpoint")
map("n", "<leader>dc", dap.continue, "Kontynuuj debugowanie")
map("n", "<leader>dr", dap.repl.open, "Otwórz REPL")
map("n", "<leader>du", dapui.toggle, "Przełącz DAP UI")
