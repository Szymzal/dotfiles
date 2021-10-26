if has('nvim-0.5.0')
	" Telescope
	nnoremap <silent> <C-p> :lua require('telescope.builtin').find_files()<cr>
	nnoremap <silent> <leader>vim :lua require('telescope_modules.vimrc_files').search_dotfiles()<cr>

	" Lspsaga
	nnoremap <silent>gh <cmd>Lspsaga lsp_finder<CR>
	" nnoremap <silent> <C-j> <cmd>Lspsaga diagnostic_jump_next<CR>
	" nnoremap <silent>K <cmd>Lspsaga hover_doc<CR>
	" inoremap <silent> <C-k> <cmd>Lspsaga signature_help<CR>

    nnoremap <silent>K <cmd>lua vim.lsp.buf.hover()<CR>
    inoremap <silent> <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
    nnoremap <silent> <C-j> <cmd>lua vim.lsp.diagnostic.goto_next({ popup_opts = { focusable = false, border = 'rounded' }})<CR>
    nnoremap <silent> <C-k> <cmd>lua vim.lsp.diagnostic.goto_prev({ popup_opts = { focusable = false, border = 'rounded' }})<CR>
endif
