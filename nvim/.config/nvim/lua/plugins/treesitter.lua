require('nvim-treesitter.configs').setup {
    ensure_installed = {
        "c",
        "cpp",
        "rust",
        "html",
        "css",
        "json",
        "toml",
        "vue",
        "javascript",
        "typescript",
        "bash",
        "markdown",
        "json5",
        "lua",
        "wgsl",
        "astro"
    },
    sync_install = false,
    highlight = {
        enable = true,
    }
}
