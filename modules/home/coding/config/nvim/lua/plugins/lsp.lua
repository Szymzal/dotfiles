return {
	{ "williamboman/mason.nvim", enabled = false },
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				gopls = {},

				lua_ls = {},

				intelephense = {},

				gleam = {},

				spyglassmc_language_server = {},

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

				nixd = {
					settings = {
						nixd = {
							nixpkgs = {
								expr = "import <nixpkgs> { }",
							},
							formatting = {
								command = { "alejandra" },
							},
							options = {
								nixos = {
									expr = '(builtins.getFlake "/persist/nixos").nixosConfigurations.machine.options',
								},
								home_manager = {
									expr = '(builtins.getFlake "/persist/nixos").homeConfigurations.szymzal.options',
								},
							},
						},
					},
				},

				html = {
					filetypes = { "html" },
					provideFormatter = false,
				},

				cssls = {},

				astro = {},
			},
		},
	},
}
