if has('nvim-0.5.0')
	" Telescope
	nnoremap <silent> <C-p> :lua require('telescope.builtin').find_files()<cr>
	nnoremap <silent> <leader>vim :lua require('telescope_modules.vimrc_files').search_dotfiles()<cr>
endif
