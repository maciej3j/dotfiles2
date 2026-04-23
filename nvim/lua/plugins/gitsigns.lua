return {
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",
  opts = {
    current_line_blame = false,        -- domyślnie wyłączone (nie zaśmieca)
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol",           -- "eol" | "overlay" | "right_align"
      delay = 300,                     -- opóźnienie w ms
      ignore_whitespace = false,
    },
    current_line_blame_formatter = "<author>, <author_time:%R> • <summary>",
  },
}
