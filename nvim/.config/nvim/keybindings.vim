if has('nvim-0.5.0')
	" Telescope
	nnoremap <silent> <C-p> :lua require('telescope.builtin').find_files()<cr>
	nnoremap <silent> <leader>vim :lua require('telescope_modules.vimrc_files').search_dotfiles()<cr>

	" Lspsaga
	nnoremap <silent>gh <cmd>Lspsaga lsp_finder<CR>

    nnoremap <silent>K <cmd>lua vim.lsp.buf.hover()<CR>
    inoremap <silent> <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
    nnoremap <silent> <C-j> <cmd>lua vim.lsp.diagnostic.goto_next({ popup_opts = { focusable = false, border = 'rounded' }})<CR>
    nnoremap <silent> <C-k> <cmd>lua vim.lsp.diagnostic.goto_prev({ popup_opts = { focusable = false, border = 'rounded' }})<CR>

    " Todo comments
    nnoremap <silent> <leader>todo <cmd>TodoTelescope<CR>

    " LuaSnip
    imap<silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
    inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>

    snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
    snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>

    imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
    smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'

endif

" Custom keybindings
nnoremap <F4> <cmd>e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>

function! SwitchAutocompletionFile()
    let path = expand('%:p')
    let check = "/src/include"
    if (stridx(path, check) == -1)
        " open autocompletion file
        let path = expand('%:p')
        let path = substitute(path, '.*\zs/src/', '/src/include/', '')
        echo path
        silent exe 'e ' . path
    else
        " open non autocompletion file
        let path = expand('%:p')
        let path = substitute(path, '.*\zs/src/include/', '/src/', '')
        echo path
        silent exe 'e ' . path
    endif
endfunction

nnoremap <silent> <F3> <cmd>call SwitchAutocompletionFile()<CR>

function! FindProjectRoot(lookFor)
    let dir = finddir('engine', expand('%:p:h').';')
    echo dir

    return dir
endfunction

function! BuildScript()
    let path = FindProjectRoot('build_options.sh')
    echo path
endfunction

nnoremap <silent> <F2> <cmd>call BuildScript()<CR>
