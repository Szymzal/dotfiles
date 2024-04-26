return {
	{
		"L3MON4D3/LuaSnip",
		config = function()
			local luasnip = require("luasnip")
			luasnip.filetype_extend("php", { "html" })

			require("luasnip/loaders/from_vscode").lazy_load()
		end,
	},
}
