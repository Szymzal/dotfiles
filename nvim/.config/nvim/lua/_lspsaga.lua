local saga = require('lspsaga')

saga.init_lsp_saga {
	use_saga_diagnostic_sign = false,
	border_style = "round",
	error_sign = '',
	warn_sign = '',
	hint_sign = '',
	infor_sign = '',
	max_preview_lines = 25,
}

vim.fn.sign_define(LspDiagnosticSignHint, { text = "", texthl = "", numhl = ""})
