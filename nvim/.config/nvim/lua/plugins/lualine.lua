require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = "sonokai"
    },
    sections = {
        lualine_c = { 'lsp_progress' }
    }
}
