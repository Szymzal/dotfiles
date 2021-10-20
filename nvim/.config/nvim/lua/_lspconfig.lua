local saga = require('lspsaga')

-- Setup language servers
local nvim_lsp = require('lspconfig')
local protocol = require('vim.lsp.protocol')

local on_attach = function(client, bufnr)
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	-- Enable completion by <c-x><c-o>
	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

	local options = { noremap=true, silent=true }

	-- :help vim.lsp.* <- for help
	buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', options)
	buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', options)
	buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', options)
	buf_set_keymap('n', '<C-y>', '<cmd>lua vim.lsp.buf.rename()<CR>', options)
end

-- C++ and C language server
nvim_lsp.ccls.setup {
	on_attach = on_attach,
	filetypes = { "cpp", "h", "hpp", "c" },
	root_dir = nvim_lsp.util.root_pattern('CMakeLists.txt', 'compile_flags.txt', 'compile_commands.json'),
	capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
}

nvim_lsp.hls.setup {}

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	virtual_text = false,
	signs = false,
	update_in_insert = false,
})

-- colors of types of diagnostic
require('lsp-colors').setup({
	Error = "#db4b4b",
	Warning = "#e0af68",
	Information = "#0db9d7",
	Hint = "#00000"
})

