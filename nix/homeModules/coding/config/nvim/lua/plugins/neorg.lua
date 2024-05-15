return {
	{
		"vhyrro/luarocks.nvim",
		priority = 1000,
		config = true,
	},
	{
		"nvim-neorg/lua-utils.nvim",
	},
	{
		"pysan3/pathlib.nvim",
	},
	{
		"nvim-neotest/nvim-nio",
	},
	{
		"nvim-neorg/neorg",
		dependencies = {
			"luarocks.nvim",
			"lua-utils.nvim",
			"pathlib.nvim",
			"nvim-nio",
		},
		lazy = false,
		config = function()
			require("neorg").setup({
				load = {
					["core.defaults"] = {},
					["core.concealer"] = {},
					["core.ui"] = {},
					["core.integrations.treesitter"] = {},
					["core.integrations.nvim-cmp"] = {},
					["core.qol.todo_items"] = {},
					["core.completion"] = {
						config = {
							engine = "nvim-cmp",
						},
					},
					["core.dirman"] = {
						config = {
							workspaces = {
								notes = "~/Notes",
							},
						},
					},
				},
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		opts = {
			sources = {
				{ name = "neorg" },
			},
		},
	},
}
