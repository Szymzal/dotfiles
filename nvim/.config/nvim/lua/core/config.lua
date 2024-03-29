local M = {}

-- nvim options
local options = vim.opt
local window = vim.wo

options.expandtab = true
options.smarttab = true
options.shiftwidth = 4
options.tabstop = 4
options.softtabstop = 4
options.hlsearch = true
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

-- colorscheme options
function M.set_color_scheme()
    vim.cmd [[ colorscheme horizon ]]
    -- disable italics and bold in places where I don't want
    vim.cmd [[ highlight Identifier cterm=none gui=none ]]
    vim.cmd [[ highlight StorageClass cterm=none gui=none ]]
    vim.cmd [[ highlight Statement cterm=none gui=none ]]
end

return M
