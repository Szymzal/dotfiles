local plugins = 'SzymzalConfig.plugins.';

return vim.tbl_deep_extend("keep", 
	require(plugins .. 'core'), 
	require(plugins .. 'lsp'), 
	require(plugins .. 'treesitter')
);
