require("arrow").setup({
    show_icons = true,
    leader_key = ";",      -- Klawisz otwierający menu szybkiego skoku
    buffer_leader_key = "m", -- Klawisz dla zakładek wewnątrz aktywnego bufora
    save_path = function()
        return vim.fn.stdpath("cache") .. "/arrow"
    end,
    mappings = {
        edit = "e",
        delete_mode = "d",
        clear_all_items = "C",
        toggle = "s",
        open_vertical = "v",
        open_horizontal = "h",
        quit = "q",
        remove = "x",
        next_item = "]",
        prev_item = "[",
    },
    custom_actions = {
        open = function(target_file_name, current_ext)
            vim.cmd("edit " .. target_file_name)
        end,
    },
})
