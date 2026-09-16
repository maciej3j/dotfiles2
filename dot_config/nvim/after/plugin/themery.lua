local all_themes = vim.fn.getcompletion("", "color")

-- 3. (Opcjonalnie) Odfiltrowanie przestarzałych, domyślnych schematów Vima
local ignore = {
    ["blue"] = true,
    ["darkblue"] = true,
    ["default"] = true,
    ["delek"] = true,
    ["desert"] = true,
    ["elflord"] = true,
    ["industry"] = true,
    ["koehler"] = true,
    ["lunaperche"] = true,
    ["morning"] = true,
    ["murphy"] = true,
    ["pablo"] = true,
    ["peachpuff"] = true,
    ["quiet"] = true,
    ["ron"] = true,
    ["shine"] = true,
    ["slate"] = true,
    ["sorbet"] = true,
    ["torte"] = true,
    ["vim"] = true,
    ["zaibatsu"] = true,
    ["zellner"] = true,
}

local available_themes = {}
for _, theme in ipairs(all_themes) do
    if not ignore[theme] then
        table.insert(available_themes, theme)
    end
end

-- 4. Inicjalizacja Themery
require("themery").setup({
    themes = available_themes, -- lub po prostu `all_themes`, jeśli chcesz widzieć absolutnie wszystko
    livePreview = true,      -- podgląd w czasie rzeczywistym
})

-- 5. Skrót klawiszowy
vim.keymap.set("n", "<leader>th", "<cmd>Themery<CR>", { desc = "Themery (Theme Picker)" })
