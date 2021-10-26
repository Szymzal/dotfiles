" Plugins
source ~/.config/nvim/plugins.vim

" General settings
source ~/.config/nvim/settings.vim
source ~/.config/nvim/theme.vim

if has('nvim-0.5.0')
	" Plugins settings
	" Fizzy Finding
	luafile ~/.config/nvim/lua/_telescope.lua

	" Autocompletion
	luafile ~/.config/nvim/lua/_lspkind.lua
	luafile ~/.config/nvim/lua/nvim-cmp.lua
	luafile ~/.config/nvim/lua/_lspsaga.lua
	luafile ~/.config/nvim/lua/_lspconfig.lua

	" Better highlighting
	luafile ~/.config/nvim/lua/treesitter.lua

    " Todo highlighting
    luafile ~/.config/nvim/lua/_todo-comments.lua
endif

source ~/.config/nvim/keybindings.vim
