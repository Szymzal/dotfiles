-- nvim options
local options = vim.opt
local window = vim.wo
local global = vim.g

global.mapleader = ' '
global.maplocalleader = ' '

options.expandtab = true
options.smarttab = true
options.shiftwidth = 4
options.tabstop = 4
options.softtabstop = 4
options.hlsearch = false
options.incsearch = true
options.ignorecase = true
options.smartcase = true
options.scrolloff = 8
options.relativenumber = true
options.nu = true
options.termguicolors = true
options.guifont = 'FiraCode Nerd Font:h14'
options.updatetime = 300
options.timeoutlen = 500
options.swapfile = false
options.showmode = false
options.autoindent = true

window.wrap = false
window.signcolumn = "yes"
