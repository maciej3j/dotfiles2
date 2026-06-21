require("vim._core.ui2").enable({
	enable = true,
})
vim.opt.termguicolors = true
vim.opt.bg = "dark"
vim.opt.number = true -- line number
vim.opt.relativenumber = true -- relative line numbers
vim.opt.cursorline = true -- highlight current line
vim.opt.wrap = false -- do not wrap lines by default
vim.opt.scrolloff = 2
vim.opt.sidescrolloff = 2
vim.opt.tabstop = 4 -- tabwidth
vim.opt.shiftwidth = 4 -- indent width
vim.opt.softtabstop = 4 -- soft tab stop not tabs on tab/backspace
vim.opt.expandtab = true -- use spaces instead of tabs
vim.opt.smartindent = true -- smart auto-indent
vim.opt.autoindent = true -- copy indent from current line
vim.opt.ignorecase = true -- case insensitive search
vim.opt.smartcase = true -- case sensitive if uppercase in string
vim.opt.hlsearch = true -- highlight search matches
vim.opt.incsearch = true -- show matches as you type
vim.opt.showmatch = true -- highlights matching brackets
vim.opt.cmdheight = 1 -- single line command line
vim.opt.completeopt = "menuone,noinsert,noselect" -- completion options
vim.opt.showmode = false -- do not show the mode, instead have it in statusline
vim.opt.pumheight = 10 -- popup menu height
vim.opt.pumblend = 10 -- popup menu transparency
vim.opt.winblend = 0 -- floating window transparency
vim.opt.conceallevel = 0 -- do not hide markup
vim.opt.concealcursor = "" -- do not hide cursorline in markup
vim.opt.synmaxcol = 300 -- syntax highlighting limit
vim.opt.fillchars = { eob = " " } -- hide "~" on empty lines

local undodir = vim.fn.expand("~/.vim/undodir")
if vim.fn.isdirectory(undodir) == 0 then -- create undodir if nonexistent
	vim.fn.mkdir(undodir, "p")
end

vim.opt.backup = false -- do not create a backup file
vim.opt.writebackup = false -- do not write to a backup file
vim.opt.swapfile = false -- do not create a swapfile
vim.opt.undofile = true -- do create an undo file
vim.opt.undodir = undodir -- set the undo directory
vim.opt.updatetime = 300 -- faster completion
vim.opt.timeoutlen = 500 -- timeout duration
vim.opt.ttimeoutlen = 50 -- key code timeout
vim.opt.autoread = true -- auto-reload changes if outside of neovim
vim.opt.autowrite = false -- do not auto-save
vim.opt.hidden = true -- allow hidden buffers
vim.opt.errorbells = false -- no error sounds
vim.opt.backspace = "indent,eol,start" -- better backspace behaviour
vim.opt.autochdir = false -- do not autochange directories
vim.opt.iskeyword:append("-") -- include - in words
vim.opt.path:append("**") -- include subdirs in search
vim.opt.selection = "inclusive" -- include last char in selection
vim.opt.mouse = "a" -- enable mouse support
vim.opt.clipboard:append("unnamedplus") -- use system clipboard
vim.opt.modifiable = true -- allow buffer modifications
vim.opt.encoding = "utf-8" -- set encoding
vim.opt.foldmethod = "expr" -- use expression for folding
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- use treesitter for folding
vim.opt.foldlevel = 99 -- start with all folds open
vim.opt.splitbelow = true -- horizontal splits go below
vim.opt.splitright = true -- vertical splits go right
vim.opt.wildmenu = true -- tab completion
vim.opt.wildmode = "longest:full,full" -- complete longest common match, full completion list, cycle through with Tab
vim.opt.diffopt:append("iwhite")
vim.diagnostic.config({ virtual_text = true, virtual_lines = false })
vim.opt.colorcolumn = "80"
vim.api.nvim_create_autocmd("Filetype", { pattern = "rust", command = "set colorcolumn=100" })
vim.opt.vb = true
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "j", function()
	return vim.v.count == 0 and "gj" or "j"
end, { expr = true, silent = true, desc = "Down (wrap-aware)" })
vim.keymap.set("n", "k", function()
	return vim.v.count == 0 and "gk" or "k"
end, { expr = true, silent = true, desc = "Up (wrap-aware)" })

-- force yourself to use the home row
vim.keymap.set("n", "<up>", "<nop>")
vim.keymap.set("n", "<down>", "<nop>")
vim.keymap.set("i", "<up>", "<nop>")
vim.keymap.set("i", "<down>", "<nop>")
vim.keymap.set("i", "<left>", "<nop>")
vim.keymap.set("i", "<right>", "<nop>")
-- let the left and right arrow be usefull: they can change buffers
vim.keymap.set("n", "<left>", ":bp<cr>")
vim.keymap.set("n", "<right>", ":bn<cr>")

vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })
vim.keymap.set("n", "<leader><leader>", "<C-^>", { desc = "Last buffer" })
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bd", ":bd<CR>", { desc = "Close buffer" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })
vim.keymap.set("n", "<leader>pa", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	print("file:", path)
end, { desc = "Copy full file path" })
vim.keymap.set("n", "<leader>td", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })

local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		vim.hl.on_yank()
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = "python",
	callback = function()
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.softtabstop = 4
	end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	desc = "Restore last cursor position",
	callback = function()
		if vim.o.diff then
			return
		end
		local last_pos = vim.api.nvim_buf_get_mark(0, '"')
		local last_line = vim.api.nvim_buf_line_count(0)
		local row = last_pos[1]
		if row < 1 or row > last_line then
			return
		end
		pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "markdown", "text", "gitcommit" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.spell = true
	end,
})

-- Native Package Array Loader
vim.pack.add({
	"https://github.com/windwp/nvim-autopairs",
	"https://www.github.com/lewis6991/gitsigns.nvim",
	-- "https://github.com/akinsho/bufferline.nvim",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/MagicDuck/grug-far.nvim",
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
	},
	"https://www.github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/saghen/blink.lib",
	{
		src = "https://github.com/saghen/blink.cmp",
		build = function()
			require("blink.cmp").build():wait(60000)
		end,
	},
	"https://github.com/L3MON4D3/LuaSnip",
	"https://github.com/tiagovla/tokyodark.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/folke/snacks.nvim",
	"https://github.com/folke/which-key.nvim",
	"https://github.com/folke/flash.nvim",
	"https://github.com/DrKJeff16/project.nvim",
	{
		src = "https://github.com/mrcjkb/rustaceanvim",
		version = vim.version.range("^9"),
	},
	"https://github.com/folke/trouble.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/mikavilpas/yazi.nvim",
	"https://github.com/rose-pine/neovim",
	"https://github.com/zaldih/themery.nvim",
	"https://github.com/ellisonleao/gruvbox.nvim",
	"https://github.com/rebelot/kanagawa.nvim",
	"https://github.com/nyoom-engineering/oxocarbon.nvim",
	"https://github.com/mcauley-penney/techbase.nvim",
	"https://github.com/wincent/base16-nvim",
	"https://github.com/ray-x/lsp_signature.nvim",
	"https://github.com/christoomey/vim-tmux-navigator",
	"https://github.com/folke/tokyonight.nvim",
	"https://github.com/AckslD/swenv.nvim",
	"https://github.com/sudo-tee/opencode.nvim",
})

local setup_treesitter = function()
	local treesitter = require("nvim-treesitter")
	treesitter.setup({})
	local ensure_installed = {
		"vim",
		"vimdoc",
		"rust",
		"c",
		"cpp",
		"go",
		"html",
		"css",
		"javascript",
		"json",
		"lua",
		"markdown",
		"python",
		"typescript",
		"vue",
		"svelte",
		"bash",
	}

	local config = require("nvim-treesitter.config")
	local already_installed = config.get_installed()
	local parsers_to_install = {}
	for _, parser in ipairs(ensure_installed) do
		if not vim.tbl_contains(already_installed, parser) then
			table.insert(parsers_to_install, parser)
		end
	end

	if #parsers_to_install > 0 then
		treesitter.install(parsers_to_install)
	end

	local group = vim.api.nvim_create_augroup("TreeSitterConfig", { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		callback = function(args)
			if vim.list_contains(treesitter.get_installed(), vim.treesitter.language.get_lang(args.match)) then
				vim.treesitter.start(args.buf)
			end
		end,
	})
end
setup_treesitter()
vim.keymap.set("x", "v", "]", { remap = true, desc = "Expand Treesitter selection" })
vim.keymap.set("x", "V", "[", { remap = true, desc = "Shrink Treesitter selection" })

vim.keymap.set("n", "<leader>e", function()
	require("snacks").explorer.open({ hidden = true })
end, { desc = "Explorer" })
vim.keymap.set("n", "<leader>E", "<cmd>Yazi<cr>", { desc = "Yazi" })

vim.keymap.set("n", "<leader>ff", function()
	require("snacks").picker.files({ hidden = true })
end, { desc = "Find File" })
vim.keymap.set("n", "<leader>fg", function()
	require("snacks").picker.grep({ hidden = true })
end, { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fb", function()
	require("snacks").picker.buffers()
end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", function()
	require("snacks").picker.tags()
end, { desc = "Help" })
vim.keymap.set("n", "<leader>fx", function()
	require("snacks").picker.diagnostics_buffer()
end, { desc = "Diagnostics buffer" })
vim.keymap.set("n", "<leader>fX", function()
	require("snacks").picker.diagnostics()
end, { desc = "Diagnostics Workspace" })

require("trouble").setup({ auto_close = true, restore = true })
vim.keymap.set("n", "[q", function()
	if require("trouble").is_open() then
		require("trouble").prev({ skip_groups = true, jump = true })
	else
		local ok, err = pcall(vim.cmd.cprev)
		if not ok then
			vim.notify(err, vim.log.levels.ERROR)
		end
	end
end, { desc = "Previous Trouble/Quickfix Item" })

vim.keymap.set("n", "]q", function()
	if require("trouble").is_open() then
		require("trouble").next({ skip_groups = true, jump = true })
	else
		local ok, err = pcall(vim.cmd.cnext)
		if not ok then
			vim.notify(err, vim.log.levels.ERROR)
		end
	end
end, { desc = "Next Trouble/Quickfix Item" })

vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
vim.keymap.set(
	"n",
	"<leader>xX",
	"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
	{ desc = "Buffer Diagnostics (Trouble)" }
)
vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
vim.keymap.set(
	"n",
	"<leader>cl",
	"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
	{ desc = "LSP Definitions / references (Trouble)" }
)
vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })
vim.keymap.set("n", "<leader>tc", "<cmd>Themery<cr>", { desc = "Open Themery" })
vim.keymap.set("n", "<leader>cv", function()
	require("swenv.api").pick_venv()
end, { desc = "Pick Python venv" })

require("gitsigns").setup({
	signs = {
		add = { text = "\u{2590}" },
		change = { text = "\u{2590}" },
		delete = { text = "\u{2590}" },
		topdelete = { text = "\u{25e6}" },
		changedelete = { text = "\u{25cf}" },
		untracked = { text = "\u{25cb}" },
	},
	signcolumn = true,
	current_line_blame = false,
})

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
		completion = {
			menu = {
				auto_show = function()
					return vim.fn.getcmdtype() == ":"
				end,
			},
		},
	},
	appearance = { nerd_font_variant = "mono" },
	completion = {
		keyword = { range = "full" },
		list = { selection = { preselect = true, auto_insert = true } },
		ghost_text = { enabled = true },
		menu = { auto_show = true },
		documentation = { auto_show = true, auto_show_delay_ms = 0 },
	},
	sources = { default = { "lsp", "path", "snippets", "buffer" } },
	snippets = {
		expand = function(snippet)
			require("luasnip").lsp_expand(snippet)
		end,
	},
})

require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "bashls", "ruff", "ty" },
	automatic_installation = true,
	handlers = {
		function(server_name)
			-- Dynamically maps blink's capabilities to servers as Mason provisions them
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			require("lspconfig")[server_name].setup({
				capabilities = capabilities,
			})
		end,
		["lua_ls"] = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			require("lspconfig").lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						telemetry = { enable = false },
					},
				},
			})
		end,
	},
})

require("lsp_signature").setup({
	bind = true,
	handler_opts = {
		border = "rounded",
	},
	hint_prefix = {
		above = "↙ ",
		current = "← ",
		below = "↖ ",
	},
	floating_window_above_cur_line = true,
	close_timeout = 4000,
	hi_parameter = "LspSignatureActiveParameter",
	toggle_key = "<C-k>", -- toggle in insert mode
	select_signature_key = "<M-n>", -- cycle overloads
})
vim.keymap.set("n", "<leader>ck", function()
	require("lsp_signature").toggle_float_win()
end, { silent = true, noremap = true, desc = "Toggle signature" })

vim.keymap.set("n", "]h", function()
	require("gitsigns").next_hunk()
end, { desc = "Next git hunk" })
vim.keymap.set("n", "[h", function()
	require("gitsigns").prev_hunk()
end, { desc = "Previous git hunk" })
vim.keymap.set("n", "<leader>hs", function()
	require("gitsigns").stage_hunk()
end, { desc = "Stage hunk" })
vim.keymap.set("n", "<leader>hr", function()
	require("gitsigns").reset_hunk()
end, { desc = "Reset hunk" })
vim.keymap.set("n", "<leader>hp", function()
	require("gitsigns").preview_hunk()
end, { desc = "Preview hunk" })
vim.keymap.set("n", "<leader>hb", function()
	require("gitsigns").blame_line({ full = true })
end, { desc = "Blame line" })
vim.keymap.set("n", "<leader>hB", function()
	require("gitsigns").toggle_current_line_blame()
end, { desc = "Toggle inline blame" })
vim.keymap.set("n", "<leader>hd", function()
	require("gitsigns").diffthis()
end, { desc = "Diff this" })

local function map(key, fn, desc)
	vim.keymap.set("n", key, fn, { noremap = true, silent = true, desc = desc })
end

map("gd", function()
	require("snacks").picker.lsp_definitions()
end, "Go to definition")
map("gS", function()
	vim.cmd("vsplit")
	vim.lsp.buf.definition()
end, "Go to definition (split)")
map("<leader>ca", function()
	require("snacks").picker.lsp_code_actions()
end, "Code action")
map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
map("<leader>D", function()
	vim.diagnostic.open_float({ scope = "line" })
end, "Line diagnostics")
map("<leader>d", function()
	vim.diagnostic.open_float({ scope = "cursor" })
end, "Cursor diagnostics")
map("<leader>nd", function()
	vim.diagnostic.jump({ count = 1 })
end, "Next diagnostic")
map("<leader>pd", function()
	vim.diagnostic.jump({ count = -1 })
end, "Prev diagnostic")
map("<leader>fr", function()
	require("grug-far").open()
end, "Search and Replace")
map("<leader>fR", function()
	require("snacks").picker.lsp_references()
end, "LSP references")
map("<leader>ft", function()
	require("snacks").picker.lsp_typedefinitions()
end, "LSP type defs")
map("<leader>fs", function()
	require("snacks").picker.lsp_symbols()
end, "LSP document symbols")
map("<leader>fi", function()
	require("snacks").picker.lsp_implementations()
end, "LSP implementations")
vim.keymap.set("n", "<leader>fp", "<cmd>ProjectSnacks<cr>", { desc = "Projects" })
vim.keymap.set("n", "<leader>-", "<cmd>Yazi toggle<cr>", { desc = "Resume Yazi" })
map("<leader>cf", function()
	vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" }, diagnostics = {} }, apply = true })
	vim.defer_fn(function()
		vim.lsp.buf.format({})
	end, 50)
end, "Organize imports & format")

vim.keymap.set("n", "<leader>q", function()
	vim.diagnostic.setloclist({ open = true })
end, { desc = "Open diagnostic list" })
vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

require("snacks").setup({
	bigfile = { enabled = true },
	dashboard = { enabled = false },
	explorer = { enabled = true },
	indent = { enabled = true },
	input = { enabled = true },
	notify = { enabled = true },
	picker = { enabled = true, ui_select = true },
	quickfile = { enabled = true },
	scope = { enabled = true },
	statuscolumn = { enabled = true },
	words = { enabled = true },
	icons = { enabled = true, style = "web-devicons" },
})

vim.keymap.set({ "n", "t" }, "<C-_>", function()
	require("snacks").terminal.toggle()
end, { desc = "Toggle terminal" })
vim.keymap.set({ "n", "t" }, "<C-/>", function()
	require("snacks").terminal.toggle()
end, { desc = "Toggle terminal" })
vim.keymap.set("n", "<leader>gg", function()
	require("snacks").lazygit()
end, { desc = "Lazygit" })

require("which-key").setup({})
require("which-key").add({
	{ "<leader>f", group = "Find" },
	{ "<leader>g", group = "Go to" },
	{ "<leader>h", group = "Git hunks" },
	{ "<leader>b", group = "Buffers" },
	{ "<leader>s", group = "Splits" },
	{ "<leader>d", group = "Diagnostics" },
	{ "<leader>t", group = "Toggle" },
	{ "<leader>o", group = "Organize" },
	{ "<leader>c", group = "Code/LSP" },
	{ "<leader>x", group = "Trouble/Diagnostics" },
	{ "]", group = "Next" },
	{ "[", group = "Prev" },
})

vim.keymap.set("n", "s", function()
	require("flash").jump()
end, { desc = "Flash" })
vim.keymap.set("i", "<C-s>", "<cmd>write<CR><Esc>", { desc = "Save file" })
-- require("bufferline").setup({})
require("lualine").setup({})
require("nvim-autopairs").setup({})

require("project").setup({
	patterns = { ".git", ".github", "package.json", "Cargo.toml", "go.mod", "pyproject.toml", "*.sln", ".nvim.lua" },
	silent_chdir = true,
	scope_chdir = "global",
	snacks = { enabled = true, opts = { sort = "newest", title = "Projects", layout = "select", show = "paths" } },
})

-- require("rose-pine").setup({
--    styles = { italic = false },
--    highlight_groups = { Comment = { italic = true } }
-- })
-- vim.cmd([[colorscheme gruvbox-dark-hard]])
require("themery").setup({
	themes = vim.fn.getcompletion("", "color"),
	livePreview = true,
})
require("opencode").setup({
	keymap_prefix = "<leader>o",
	opencode_executable = "opencode",
	persist_state = true,
	ui = {
		picker = {
			snacks_layout = {
				layout = {
					border = "rounded",
					box = "vertical",
				},
			},
		},
	},
})

vim.keymap.set(
	{ "n", "v" },
	"<leader>oo",
	"<cmd>OpencodeToggle<cr>",
	{ desc = "Otwórz/Przełącz panel chatu OpenCode" }
)
vim.keymap.set("n", "<leader>ot", "<cmd>OpencodeToggleFocus<cr>", { desc = "Przełącz focus między kodem a chatem" })
vim.keymap.set("n", "<leader>op", "<cmd>OpencodeModelPicker<cr>", { desc = "Wybór modelu AI" })
vim.keymap.set({ "n", "x" }, "<leader>oa", function()
	require("opencode").quick_chat()
end, { desc = "Zadaj pytanie OpenCode (z kontekstem kodu)" })
vim.lsp.inlay_hint.enable(true)
vim.keymap.set("n", "<leader>th", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle inlay hints" })
