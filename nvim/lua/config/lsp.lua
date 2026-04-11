-- Wczytaj to np. w init.lua: require('config.lsp')
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME },
      },
      telemetry = { enable = false },
    },
  },
})

vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = { command = "clippy" },
      cargo = { allFeatures = true },
    },
  },
})

-- Diagnostics (ładne i czytelne)
vim.diagnostic.config({
  severity_sort = true,
  update_in_insert = false,
  float = { border = "rounded", source = "if_many" },
  underline = true,
  virtual_text = {
    spacing = 2,
    source = "if_many",
    prefix = "●",
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "E",
      [vim.diagnostic.severity.WARN]  = "W",
      [vim.diagnostic.severity.INFO]  = "I",
      [vim.diagnostic.severity.HINT]  = "H",
    },
  },
})

-- Keymapy na LspAttach (to czego chciałeś: <leader>gd, <leader>gr itd.)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
    end

    -- Najczęściej używane z leaderem
    map("n", "<leader>gd", vim.lsp.buf.definition,      "Go to definition")
    map("n", "<leader>gD", vim.lsp.buf.declaration,     "Go to declaration")
    map("n", "<leader>gi", vim.lsp.buf.implementation,  "Go to implementation")
    map("n", "<leader>gr", vim.lsp.buf.references,      "References")
    map("n", "<leader>rn", vim.lsp.buf.rename,          "Rename")
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")

    -- Hover i inne przydatne
    map("n", "K", vim.lsp.buf.hover, "Hover documentation")
    map("n", "<leader>ds", vim.lsp.buf.document_symbol, "Document symbols")

    -- Formatowanie
    map("n", "<leader>f", function()
      vim.lsp.buf.format({ async = true })
    end, "Format buffer")
  end,
})
