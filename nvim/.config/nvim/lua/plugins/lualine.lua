require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = "horizon"
    },
    sections = {
        lualine_c = { 'lsp_progress' }
    }
}
