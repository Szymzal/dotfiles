vim.api.nvim_command('set suffixesadd+=.lua')
vim.api.nvim_command('set suffixesadd+=init.lua')
vim.api.nvim_command('set path+=' .. vim.fn.stdpath('config') .. '/lua')
