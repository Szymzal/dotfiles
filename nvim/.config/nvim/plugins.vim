call plug#begin(stdpath('data') . '\plugged')
" Plugins

" Theme
Plug 'sainnhe/sonokai'

" Lightline
Plug 'itchyny/lightline.vim'

if has('nvim-0.5.0')
	" Better syntax highlighing
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

	" Telescope
	" Plenary is required for telescope to work
	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-telescope/telescope.nvim'
	Plug 'nvim-telescope/telescope-fzy-native.nvim'

	" LSP
	Plug 'neovim/nvim-lspconfig'
	Plug 'folke/lsp-colors.nvim'
	Plug 'glepnir/lspsaga.nvim'

	" Autocompletion LSP
	" Plug 'hrsh7th/nvim-compe'
	Plug 'hrsh7th/cmp-nvim-lsp'
	Plug 'hrsh7th/cmp-buffer'
	Plug 'hrsh7th/nvim-cmp'
	" Plug 'nvim-lua/completion-nvim'

	" AutoFill
	Plug 'L3MON4D3/LuaSnip'
	Plug 'saadparwaiz1/cmp_luasnip'

	" Customize autocompletion box
	Plug 'onsails/lspkind-nvim'
endif
call plug#end()