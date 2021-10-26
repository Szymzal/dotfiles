if has('nvim-0.5.0')
	" Telescope
	nnoremap <silent> <C-p> :lua require('telescope.builtin').find_files()<cr>
	nnoremap <silent> <leader>vim :lua require('telescope_modules.vimrc_files').search_dotfiles()<cr>

	" Lspsaga
	nnoremap <silent> <C-j> <cmd>Lspsaga diagnostic_jump_next<CR>
	nnoremap <silent>K <cmd>Lspsaga hover_doc<CR>
	inoremap <silent> <C-k> <cmd>Lspsaga signature_help<CR>
	nnoremap <silent>gh <cmd>Lspsaga lsp_finder<CR>
endif
