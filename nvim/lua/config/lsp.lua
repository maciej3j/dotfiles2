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

    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")

    -- Hover i inne przydatne
    map("n", "K", vim.lsp.buf.hover, "Hover documentation")
    map("n", "<leader>cs", vim.lsp.buf.document_symbol, "Document symbols")

    -- Formatowanie
    map("n", "<leader>cf", function()
      vim.lsp.buf.format({ async = true })
    end, "Format buffer")
  end,
})
