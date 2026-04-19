return
-- {
-- 	"rose-pine/neovim",
-- 	name = "rose-pine",
-- 	config = function()
-- 		vim.cmd("colorscheme rose-pine")
-- 	end
-- }
-- {
--   "zootedb0t/citruszest.nvim",
--   lazy = false,
--   priority = 1000,
-- 	config = function()
-- 		vim.cmd("colorscheme citruszest")
-- 	end
-- }
{
    "tiagovla/tokyodark.nvim",
    opts = {
        -- custom options here
    },
    config = function(_, opts)
        require("tokyodark").setup(opts) -- calling setup is optional
        vim.cmd [[colorscheme tokyodark]]
    end,
}
