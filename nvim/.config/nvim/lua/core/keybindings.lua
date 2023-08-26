local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap('n', '<c-j>', '<c-w>j', opts)
keymap('n', '<c-h>', '<c-w>h', opts)
keymap('n', '<c-k>', '<c-w>k', opts)
keymap('n', '<c-l>', '<c-w>l', opts)

keymap('n', '<leader>ff', require("telescope.builtin").find_files, opts)
keymap('n', '<leader>vim', require("custom.telescope").search_vimrc, opts)
keymap('n', '<leader>u', function() require("telescope.builtin").lsp_references() end, opts)
