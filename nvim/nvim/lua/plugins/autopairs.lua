return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    check_ts = true,
    ts_config = {
      lua = { "string", "source" },
    },
    -- wyłącz conflict z blink (jeśli masz problemy)
    -- enable_check_bracket_line = false,
  }
}
