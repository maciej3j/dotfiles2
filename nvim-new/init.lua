vim.opt.shell = 'pwsh.exe'
require('vim._core.ui2').enable({
   enable = true,
   msg = {
      targets = {
         [''] = 'msg',
         empty = 'cmd',
         bufwrite = 'msg',
         confirm = 'cmd',
         emsg = 'pager',
         echo = 'msg',
         echomsg = 'msg',
         echoerr = 'pager',
         completion = 'cmd',
         list_cmd = 'pager',
         lua_error = 'pager',
         lua_print = 'msg',
         progress = 'pager',
         rpc_error = 'pager',
         quickfix = 'msg',
         search_cmd = 'cmd',
         search_count = 'cmd',
         shell_cmd = 'pager',
         shell_err = 'pager',
         shell_out = 'pager',
         shell_ret = 'msg',
         undo = 'msg',
         verbose = 'pager',
         wildlist = 'cmd',
         wmsg = 'msg',
         typed_cmd = 'cmd',
      },
      cmd = {
         height = 0.5,
      },
      dialog = {
         height = 0.5,
      },
      msg = {
         height = 0.3,
         timeout = 5000,
      },
      pager = {
         height = 0.5,
      },
   },
})

vim.opt.termguicolors = true


local function set_transparent() -- set UI component to transparent
   local groups = {
      "Normal",
      "NormalNC",
      "EndOfBuffer",
      "NormalFloat",
      "FloatBorder",
      "SignColumn",
      "StatusLine",
      "StatusLineNC",
      "TabLine",
      "TabLineFill",
      "TabLineSel",
      "ColorColumn",
   }
   for _, g in ipairs(groups) do
      vim.api.nvim_set_hl(0, g, { bg = "none" })
   end
   vim.api.nvim_set_hl(0, "TabLineFill", { bg = "none", fg = "#767676" })
end

set_transparent()

-- ============================================================================
-- OPTIONS
-- ============================================================================
vim.opt.number = true         -- line number
vim.opt.relativenumber = true -- relative line numbers
vim.opt.cursorline = true     -- highlight current line
vim.opt.wrap = false          -- do not wrap lines by default
vim.opt.scrolloff = 10        -- keep 10 lines above/below cursor
vim.opt.sidescrolloff = 10    -- keep 10 lines to left/right of cursor

vim.opt.tabstop = 3           -- tabwidth
vim.opt.shiftwidth = 3        -- indent width
vim.opt.softtabstop = 3       -- soft tab stop not tabs on tab/backspace
vim.opt.expandtab = true      -- use spaces instead of tabs
vim.opt.smartindent = true    -- smart auto-indent
vim.opt.autoindent = true     -- copy indent from current line

vim.opt.ignorecase = true     -- case insensitive search
vim.opt.smartcase = true      -- case sensitive if uppercase in string
vim.opt.hlsearch = true       -- highlight search matches
vim.opt.incsearch = true      -- show matches as you type

-- vim.opt.signcolumn = "yes" -- always show a sign column
-- vim.opt.colorcolumn = "100" -- show a column at 100 position chars
vim.opt.showmatch = true                          -- highlights matching brackets
vim.opt.cmdheight = 1                             -- single line command line
vim.opt.completeopt = "menuone,noinsert,noselect" -- completion options
vim.opt.showmode = false                          -- do not show the mode, instead have it in statusline
vim.opt.pumheight = 10                            -- popup menu height
vim.opt.pumblend = 10                             -- popup menu transparency
vim.opt.winblend = 0                              -- floating window transparency
vim.opt.conceallevel = 0                          -- do not hide markup
vim.opt.concealcursor = ""                        -- do not hide cursorline in markup
-- vim.opt.lazyredraw = true                         -- do not redraw during macros
vim.opt.synmaxcol = 300                           -- syntax highlighting limit
vim.opt.fillchars = { eob = " " }                 -- hide "~" on empty lines

local undodir = vim.fn.expand("~/.vim/undodir")
if
    vim.fn.isdirectory(undodir) == 0 -- create undodir if nonexistent
then
   vim.fn.mkdir(undodir, "p")
end

vim.opt.backup = false                  -- do not create a backup file
vim.opt.writebackup = false             -- do not write to a backup file
vim.opt.swapfile = false                -- do not create a swapfile
vim.opt.undofile = true                 -- do create an undo file
vim.opt.undodir = undodir               -- set the undo directory
vim.opt.updatetime = 300                -- faster completion
vim.opt.timeoutlen = 500                -- timeout duration
vim.opt.ttimeoutlen = 50                -- key code timeout
vim.opt.autoread = true                 -- auto-reload changes if outside of neovim
vim.opt.autowrite = false               -- do not auto-save

vim.opt.hidden = true                   -- allow hidden buffers
vim.opt.errorbells = false              -- no error sounds
vim.opt.backspace = "indent,eol,start"  -- better backspace behaviour
vim.opt.autochdir = false               -- do not autochange directories
vim.opt.iskeyword:append("-")           -- include - in words
vim.opt.path:append("**")               -- include subdirs in search
vim.opt.selection = "inclusive"         -- include last char in selection
vim.opt.mouse = "a"                     -- enable mouse support
vim.opt.clipboard:append("unnamedplus") -- use system clipboard
vim.opt.modifiable = true               -- allow buffer modifications
vim.opt.encoding = "utf-8"              -- set encoding

-- vim.opt.guicursor = ""

-- Folding: requires treesitter available at runtime; safe fallback if not
vim.opt.foldmethod = "expr"                          -- use expression for folding
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- use treesitter for folding
vim.opt.foldlevel = 99                               -- start with all folds open

vim.opt.splitbelow = true                            -- horizontal splits go below
vim.opt.splitright = true                            -- vertical splits go right

vim.opt.wildmenu = true                              -- tab completion
vim.opt.wildmode =
"longest:full,full"                                  -- complete longest common match, full completion list, cycle through with Tab
vim.opt.diffopt:append("linematch:60")               -- improve diff display
vim.opt.redrawtime = 10000                           -- increase neovim redraw tolerance
vim.opt.maxmempattern = 20000                        -- increase max memory

-- ============================================================================
-- KEYMAPS
-- ============================================================================
vim.g.mapleader = " "      -- space for leader
vim.g.maplocalleader = " " -- space for localleader

-- better movement in wrapped text
vim.keymap.set("n", "j", function()
   return vim.v.count == 0 and "gj" or "j"
end, { expr = true, silent = true, desc = "Down (wrap-aware)" })
vim.keymap.set("n", "k", function()
   return vim.v.count == 0 and "gk" or "k"
end, { expr = true, silent = true, desc = "Up (wrap-aware)" })


vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })
vim.keymap.set({ "n", "v" }, "<leader>x", '"_d', { desc = "Delete without yanking" })

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

vim.keymap.set("n", "<leader>pa", function() -- show file path
   local path = vim.fn.expand("%:p")
   vim.fn.setreg("+", path)
   print("file:", path)
end, { desc = "Copy full file path" })

vim.keymap.set("n", "<leader>td", function()
   vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })

-- ============================================================================
-- AUTOCMDS
-- ============================================================================

local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
   group = augroup,
   callback = function()
      vim.hl.on_yank()
   end,
})

-- return to last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
   group = augroup,
   desc = "Restore last cursor position",
   callback = function()
      if vim.o.diff then -- except in diff mode
         return
      end

      local last_pos = vim.api.nvim_buf_get_mark(0, '"') -- {line, col}
      local last_line = vim.api.nvim_buf_line_count(0)

      local row = last_pos[1]
      if row < 1 or row > last_line then
         return
      end

      pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
   end,
})

-- wrap, linebreak and spellcheck on markdown and text files
vim.api.nvim_create_autocmd("FileType", {
   group = augroup,
   pattern = { "markdown", "text", "gitcommit" },
   callback = function()
      vim.opt_local.wrap = true
      vim.opt_local.linebreak = true
      vim.opt_local.spell = true
   end,
})
-- ============================================================================
-- PLUGINS (vim.pack)
-- ============================================================================
vim.pack.add({
   "https://github.com/windwp/nvim-autopairs",
   "https://www.github.com/lewis6991/gitsigns.nvim",
   "https://github.com/akinsho/bufferline.nvim",
   "https://github.com/nvim-lualine/lualine.nvim",
   "https://www.github.com/echasnovski/mini.nvim",
   "https://www.github.com/ibhagwan/fzf-lua",
   {
      src = "https://github.com/nvim-treesitter/nvim-treesitter",
      branch = "main",
      build = ":TSUpdate",
   },
   -- Language Server Protocols
   "https://www.github.com/neovim/nvim-lspconfig",
   "https://github.com/mason-org/mason.nvim",
   "https://github.com/saghen/blink.lib",
   {
      src = "https://github.com/saghen/blink.cmp",
      build = function()
         require('blink.cmp').build():wait(60000)
      end,
   },
   "https://github.com/L3MON4D3/LuaSnip",
   "https://github.com/tiagovla/tokyodark.nvim",
   "https://github.com/nvim-tree/nvim-web-devicons",
   "https://github.com/folke/snacks.nvim",
   "https://github.com/ellisonleao/gruvbox.nvim",
   "https://github.com/folke/which-key.nvim",
   "https://github.com/folke/flash.nvim",
   "https://github.com/DrKJeff16/project.nvim",
   {
      src = 'https://github.com/mrcjkb/rustaceanvim',
      version = vim.version.range('^9')
   },
   "https://github.com/folke/trouble.nvim",
})

local function packadd(name)
   vim.cmd("packadd " .. name)
end
packadd("nvim-treesitter")
packadd("gitsigns.nvim")
packadd("mini.nvim")
packadd("nvim-web-devicons")
packadd("fzf-lua")
-- LSP
packadd("nvim-lspconfig")
packadd("mason.nvim")
packadd("blink.cmp")
packadd("snacks.nvim")
packadd("which-key.nvim")
packadd("LuaSnip")
packadd("flash.nvim")
packadd("bufferline.nvim")
packadd("project.nvim")
packadd("trouble.nvim")
-- packadd("gruvbox.nvim")

-- ============================================================================
-- PLUGIN CONFIGS
-- ============================================================================
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

vim.keymap.set("n", "<leader>e", function()
   require("snacks").explorer.open()
end, { desc = "Explorer" })
vim.keymap.set("n", "<leader>E", function()
   require("snacks").explorer.reveal()
end, { desc = "Explorer Open" })

vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "NvimTreeSignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none" })
vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { fg = "#2a2a2a", bg = "none" })
vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = "none" })

require("fzf-lua").setup({})

vim.keymap.set("n", "<leader>ff", function()
   require("snacks").picker.files()
end, { desc = "Find File" })
vim.keymap.set("n", "<leader>fg", function()
   require("snacks").picker.grep()
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
require("trouble").setup({
  auto_close = true, -- automatycznie zamknij gdy otworzysz plik
  restore = true,    -- przywróć widok po ponownym otwarciu
})
vim.keymap.set("n", "[q", function()
  if require("trouble").is_open() then
    require("trouble").prev({ skip_groups = true, jump = true })
  else
    local ok, err = pcall(vim.cmd.cprev)
    if not ok then vim.notify(err, vim.log.levels.ERROR) end
  end
end, { desc = "Previous Trouble/Quickfix Item" })

vim.keymap.set("n", "]q", function()
  if require("trouble").is_open() then
    require("trouble").next({ skip_groups = true, jump = true })
  else
    local ok, err = pcall(vim.cmd.cnext)
    if not ok then vim.notify(err, vim.log.levels.ERROR) end
  end
end, { desc = "Next Trouble/Quickfix Item" })
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
vim.keymap.set("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", { desc = "LSP Definitions / references (Trouble)" })
vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })
require("mini.ai").setup({})
require("mini.comment").setup({})
require("mini.move").setup({})
-- require("mini.surround").setup({})
require("mini.cursorword").setup({})
require("mini.indentscope").setup({})
require("mini.trailspace").setup({})
require("mini.bufremove").setup({})
require("mini.notify").setup({})

require("gitsigns").setup({
   signs = {
      add = { text = "\u{2590}" },          -- ▏
      change = { text = "\u{2590}" },       -- ▐
      delete = { text = "\u{2590}" },       -- ◦
      topdelete = { text = "\u{25e6}" },    -- ◦
      changedelete = { text = "\u{25cf}" }, -- ●
      untracked = { text = "\u{25cb}" },    -- ○
   },
   signcolumn = true,
   current_line_blame = false,
})

require("mason").setup({})

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

-- ============================================================================
-- LSP, Linting, Formatting & Completion
-- ============================================================================
local diagnostic_signs = {
   Error = " ",
   Warn = " ",
   Hint = "",
   Info = "",
}

vim.diagnostic.config({
   virtual_text = { prefix = "●", spacing = 4 },
   signs = {
      text = {
         [vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
         [vim.diagnostic.severity.WARN] = diagnostic_signs.Warn,
         [vim.diagnostic.severity.INFO] = diagnostic_signs.Info,
         [vim.diagnostic.severity.HINT] = diagnostic_signs.Hint,
      },
   },
   underline = true,
   update_in_insert = false,
   severity_sort = true,
   float = {
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
      focusable = false,
      style = "minimal",
   },
})

do
   local orig = vim.lsp.util.open_floating_preview
   function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
      opts = opts or {}
      opts.border = opts.border or "rounded"
      return orig(contents, syntax, opts, ...)
   end
end

local function map(key, fn, desc)
   vim.keymap.set("n", key, fn, { noremap = true, silent = true, desc = desc })
end

map("gd", function() require("snacks").picker.lsp_definitions() end,
   "Go to definition")
map("gS", function()
   vim.cmd("vsplit"); vim.lsp.buf.definition()
end, "Go to definition (split)")
map("<leader>ca", function() require("fzf-lua").lsp_code_actions() end, "Code action")
map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
map("<leader>D", function() vim.diagnostic.open_float({ scope = "line" }) end, "Line diagnostics")
map("<leader>d", function() vim.diagnostic.open_float({ scope = "cursor" }) end, "Cursor diagnostics")
map("<leader>nd", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")
map("<leader>pd", function() vim.diagnostic.jump({ count = -1 }) end, "Prev diagnostic")
map("K", vim.lsp.buf.hover, "Hover docs")
map("<leader>fr", function() require("snacks").picker.lsp_references() end, "LSP references")
map("<leader>ft", function() require("snacks").picker.lsp_typedefinitions() end, "LSP type defs")
map("<leader>fs", function() require("snacks").picker.lsp_symbols() end, "LSP document symbols")
map("<leader>fi", function() require("snacks").picker.lsp_implementations() end, "LSP implementations")
vim.keymap.set("n", "<leader>fp", "<cmd>ProjectSnacks<cr>", { desc = "Projects" })
map("<leader>cf", function()
   vim.lsp.buf.code_action({
      context = { only = { "source.organizeImports" }, diagnostics = {} },
      apply = true,
   })
   vim.defer_fn(function()
      vim.lsp.buf.format({})
   end, 50)
end, "Organize imports & format")

-- vim.api.nvim_create_autocmd("LspAttach", { group = augroup, callback = lsp_on_attach })

vim.keymap.set("n", "<leader>q", function()
   vim.diagnostic.setloclist({ open = true })
end, { desc = "Open diagnostic list" })
vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

require("blink.cmp").setup({
   fuzzy = { implementation = "lua" },
   keymap = {
      preset = "none",
      ["<C-Space>"] = { "show", "hide" },
      ["<CR>"] = { "accept", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<Tab>"] = { "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },
   },
   appearance = { nerd_font_variant = "mono" },
   completion = { menu = { auto_show = true } },
   sources = { default = { "lsp", "path", "buffer", "snippets" } },
   snippets = {
      expand = function(snippet)
         require("luasnip").lsp_expand(snippet)
      end,
   },
})

vim.lsp.config["*"] = {
   capabilities = require("blink.cmp").get_lsp_capabilities(),
}

vim.lsp.config("lua_ls", {
   settings = {
      Lua = {
         diagnostics = { globals = { "vim" } },
         telemetry = { enable = false },
      },
   },
})
-- vim.lsp.config("pyright", {})
vim.lsp.config("bashls", {})
vim.lsp.config("ts_ls", {})
vim.lsp.config("gopls", {})
vim.lsp.config("clangd", {})

vim.lsp.enable({
   "lua_ls",
   -- "pyright",
   "ty",
   "ruff",
   "bashls",
   "ts_ls",
   "gopls",
   "clangd",
   -- "rust_analyzer",
})

-- SNACKS
require("snacks").setup({
   bigfile = { enabled = true },
   dashboard = { enabled = false },
   explorer = { enabled = true },
   indent = { enabled = true },
   input = { enabled = true },
   picker = { enabled = true },
   quickfile = { enabled = true },
   scope = { enabled = true },
   statuscolumn = { enabled = true },
   words = { enabled = true },
   icons = {
      enabled = true,
      style = "web-devicons",
   },
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
   { "<leader>c", group = "Code/LSP"},
   { "<leader>x", group = "Trouble/Diagnostics" },
   { "]",         group = "Next" },
   { "[",         group = "Prev" },
})

vim.keymap.set("n", "s", function() require("flash").jump() end, { desc = "Flash" })
require("bufferline").setup {}
require("lualine").setup {}
require("nvim-autopairs").setup {}
require("project").setup({
   patterns = {
      ".git",
      ".github",
      "package.json",
      "Cargo.toml",
      "go.mod",
      "pyproject.toml",
      "*.sln",
      ".nvim.lua",
   },
   silent_chdir = true,
   scope_chdir = "global",
   snacks = {
      enabled = true,
      opts = {
         sort = "newest",
         title = "Projects",
         layout = "select",
         show = "paths",
      },
   },
   fzf_lua = {
      enabled = true,
      sort = "newest",
   },
})
vim.cmd.colorscheme("tokyodark")
if vim.g.neovide then
   vim.o.guifont = "FiraCode Nerd Font"
   vim.api.nvim_set_keymap('n', '<F11>', ":let g:neovide_fullscreen = !g:neovide_fullscreen<CR>", {})
end
