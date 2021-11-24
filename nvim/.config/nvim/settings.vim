" General settings of vim
set exrc
set relativenumber
set noerrorbells
set nu
set expandtab
set smarttab
set scrolloff=8
set tabstop=4 softtabstop=4
set shiftwidth=4
set nohlsearch
set hidden
set nowrap
set signcolumn=yes
set mouse=a

" WSL yank support
let s:clip = '/mnt/c/Windows/System32/clip.exe'
if executable(s:clip)
    augroup WSLYank
        autocmd!
        autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
    augroup END
endif

lua << EOF
package.path = package.path .. ";/home/szymzal/.config/nvim/lua/?.lua;/home/szymzal/.config/nvim/?.lua"
EOF
