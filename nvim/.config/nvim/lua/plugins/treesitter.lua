require('nvim-treesitter.configs').setup {
    ensure_installed = { "c", "cpp", "rust" },
    sync_install = false,
    highlight = {
        enable = true,
    }
}
