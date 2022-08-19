require('nvim-treesitter.configs').setup {
    ensure_installed = { "c", "cpp", "rust", "html", "css", "json", "toml", "vue", "javascript", "typescript", "bash", "markdown", "json5", "lua" },
    sync_install = false,
    highlight = {
        enable = true,
    }
}
