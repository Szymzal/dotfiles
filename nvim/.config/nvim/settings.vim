" General settings of vim
set shell=/bin/bash
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

lua << EOF
package.path = package.path .. ";/home/szymzal/.config/nvim/lua/?.lua;/home/szymzal/.config/nvim/?.lua"
EOF