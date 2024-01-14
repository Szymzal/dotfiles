return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rust_analyzer = {
          mason = false,
        },

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
	  mason = false,
        },

        html = {
          filetypes = { "html" },
          provideFormatter = false,
	  mason = false,
        },

        cssls = {
	  mason = false,
	},

        bashls = {
	  mason = false,
	},

        wgsl_analyzer = {
          filetypes = { "wgsl" },
	  mason = false,
        },

        astro = {
	  mason = false,
	},
      },
    },
  },
}
