return {
	{ "williamboman/mason.nvim", enabled = false },
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				-- rust_analyzer = {},

				lua_ls = {},

				-- phpactor = {},

				intelephense = {},

				tsserver = {
					settings = {
						Lua = {
							runtime = {
								version = "LuaJIT",
							},
							diagnostics = {
								globals = { "vim" },
							},
							workspace = {
								library = vim.api.nvim_get_runtime_file("", true),
							},
							telemetry = {
								enable = false,
							},
						},
					},
				},

				nil_ls = {},

				html = {
					filetypes = { "html" },
					provideFormatter = false,
				},

				cssls = {},

				-- astro = {},
			},
		},
	},
}
