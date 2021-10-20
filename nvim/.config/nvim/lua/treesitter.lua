require('nvim-treesitter.install').compilers = { "gcc" }

require('nvim-treesitter.configs').setup {
	ensure_installed = {
		"lua",
		"cpp",
		"c"
	},
	highlight = {
		enable = true,
	},
	indent = {
		enable = true
	}
}
