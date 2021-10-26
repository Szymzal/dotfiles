require('lspsaga').init_lsp_saga {
	use_saga_diagnostic_sign = true,
	border_style = "round",
	error_sign = '',
	warn_sign = '',
    hint_sign = '',
	infor_sign = '',
    -- This diables the annoying light bulb
    code_action_prompt = {
        enable = false,
        sign = false,
        sign_priority = 0,
        virtual_text = false,
    },
	max_preview_lines = 25,
}
