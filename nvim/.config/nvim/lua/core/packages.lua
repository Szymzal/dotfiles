require('packer').startup(function(use)
    use { 'lewis6991/impatient.nvim', config = [[require('impatient')]] }

    use 'wbthomason/packer.nvim'

    use { 'neovim/nvim-lspconfig' }
    use { 'onsails/lspkind-nvim', event = 'VimEnter' }
    use { 'hrsh7th/nvim-cmp', after = 'lspkind-nvim', config = [[require('plugins/nvim-cmp')]] }
    -- I have no idea why lspconfig config needs to be here otherwise on_attach keymaps dont apply
    use { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp', config = [[require('plugins/lspconfig')]] }
    use { 'hrsh7th/cmp-nvim-lsp-signature-help', after = { 'nvim-cmp', 'cmp-nvim-lsp' } }
    use { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' }
    use { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' }
    use { 'hrsh7th/cmp-path', after = 'nvim-cmp' }
    use { 'quangnguyen30192/cmp-nvim-ultisnips', after = { 'nvim-cmp', 'ultisnips' } }
    use { 'SirVer/ultisnips', event = 'InsertEnter' }
    use { 'honza/vim-snippets', after = 'ultisnips' }
    use { 'ray-x/lsp_signature.nvim', config = [[require('plugins/lsp-signature')]] }

    use 'sainnhe/sonokai'
    use { 'nvim-treesitter/nvim-treesitter', run = ":TSUpdate", config = [[require('plugins/treesitter')]] }

    use { 'arkav/lualine-lsp-progress' }
    use { 'nvim-lualine/lualine.nvim', after = 'lualine-lsp-progress', requires = { 'kyazdani42/nvim-web-devicons', opt = true }, config = [[require('plugins/lualine')]] }

    use { 'nvim-telescope/telescope.nvim', requires = { {'nvim-lua/plenary.nvim'} }, config = [[require('plugins/telescope')]] }

    use { 'mhinz/vim-signify', event = "VimEnter" }
    use { 'Raimondi/delimitMate', event = "InsertEnter" }
    use { 'tpope/vim-commentary', event = "VimEnter" }
    use { 'tpope/vim-fugitive', event = "User InGitRepo" }

    use { 'goolord/alpha-nvim', requires = { 'kyazdani42/nvim-web-devicons' }, config = function()
            require('alpha').setup(require('alpha.themes.dashboard').config)
        end
    }

    use { 'simrat39/rust-tools.nvim', after = 'nvim-lspconfig', config = [[require('plugins/rust-tools')]] }
    use { 'timonv/vim-cargo' }
end)
