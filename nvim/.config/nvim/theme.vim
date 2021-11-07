" The terminal settings
set termguicolors
set noshowmode

" The lightline theme settings
let g:sonokai_style = 'andromeda'

let g:sonokai_diagnostic_line_highlight = 1
let g:sonokai_diagnostic_text_highlight = 1
let g:sonokai_diagnostic_virtual_text = 'colored'

colorscheme sonokai

" Lightline setup
 let g:lightline = {
		\ 'colorscheme': 'sonokai',
		\ 'active' : {
		\	'left': [ [ 'mode', 'paste' ],
		\			  [ 'readonly', 'fugitive', 'filename', 'errors', 'warnings', 'ok', 'modified'  ] ]
		\ },
		\ 'component': {
		\   'lineinfo': ' %3l:%-2v'
        \ },
	    \ 'component_function': {
		\   'readonly': 'LightlineReadonly',
		\   'fugitive': 'LightlineFugitive'
		\ },
		\ 'component_expand': {
		\	'errors': 'LightlineErrors',
		\	'warnings': 'LightlineWarnings',
		\	'ok': 'LightlineOk'
		\ },
		\ 'component_type': {
		\	'errors': 'error',
		\	'warnings': 'warning',
		\ },
		\ }

 let s:palette = g:lightline#colorscheme#{g:lightline.colorscheme}#palette
 let s:palette.normal.middle = [ [ 'NONE', 'NONE', 'NONE', 'NONE' ] ]
 let s:palette.inactive.middle = s:palette.normal.middle
 let s:palette.tabline.middle = s:palette.normal.middle
 let s:palette.insert.middle = s:palette.normal.middle
 let s:palette.visual.middle = s:palette.normal.middle
 let s:palette.command.middle = s:palette.normal.middle

" The Read only files icon
function! LightlineReadonly()
	return &readonly ? '' : ''
endfunction

" The branch icon and name of it
function! LightlineFugitive()
	if exists('*fugitive#head')
		let branch = fugitive#head()
		return branch !=# '' ? ''.branch : ''
	endif
	return ''
endfunction

" The number of errors in file
function! LightlineErrors()
	let errorCount = luaeval("vim.lsp.diagnostic.get_count(0, [[Error]])")

	return errorCount == 0 ? '' : printf(' %d', errorCount)
endfunction

" The number of warnings in file
function! LightlineWarnings()
	let WarningCount = luaeval("vim.lsp.diagnostic.get_count(0, [[Warning]])")

	return WarningCount == 0 ? '' : printf(' %d', WarningCount)
endfunction

" OK icon when there is no errors or warnings
function! LightlineOk()
	let errorCount = luaeval("vim.lsp.diagnostic.get_count(0, [[Error]])")
	let warningCount = luaeval("vim.lsp.diagnostic.get_count(0, [[Warning]])")
	
	return errorCount == 0 ? warningCount == 0 ? ' ' : '' : ''
endfunction

" The update call to know is there any errors or warnings in file
augroup _lightline
	autocmd!
	autocmd InsertEnter,InsertLeave,BufEnter,BufRead,BufLeave,BufWritePost * call lightline#update()
augroup END

highlight Normal guibg=none
highlight NonText guibg=none
highlight EndOfBuffer guibg=none
