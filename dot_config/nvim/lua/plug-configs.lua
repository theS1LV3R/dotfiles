require("nvim-tree").setup({
    open_on_setup = true,
    open_on_setup_file = true
})

require("presence"):setup({
    auto_update = true,
    neovim_image_text = "nvim > vim",
    main_image = "file",
    buttons = false,
    enable_line_number = false
})
