-- Add wgsl filetype recognision
vim.cmd [[ au BufNewFile,BufRead *.wgsl set filetype=wgsl ]]
vim.cmd [[ autocmd BufRead,BufEnter *.astro set filetype=astro ]]
