require("lazy").setup({
    'tpope/vim-fugitive',
    'tpope/vim-rhubarb',
    {
        'lewis6991/impatient.nvim',
        lazy = false,
        config = function ()
            require('impatient')
        end
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'j-hui/fidget.nvim', opts = {} },
            'folke/neodev.nvim',
        },
        config = function()
            require('plugins/lspconfig')
        end
    },
    {
        'onsails/lspkind-nvim',
        event = 'VimEnter'
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            {
                'hrsh7th/cmp-nvim-lsp',
                dependencies = { 'hrsh7th/cmp-nvim-lsp-signature-help' }
            },
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip'
        },
        config = function()
            require('plugins/nvim-cmp')
        end
    },
    {
        'ray-x/lsp_signature.nvim',
        config = function()
            require('plugins/lsp-signature')
        end
    },
    {
        'folke/which-key.nvim', opts = {}
    },
    {
        'sainnhe/sonokai',
        priority = 1000,
        lazy = false,
        config = function()
            vim.cmd [[ let g:sonokai_style = 'andromeda' ]]
            vim.cmd.colorscheme 'sonokai'
        end
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            { 'kyazdani42/nvim-web-devicons', opts = {} }
        },
        config = function ()
            require('plugins/lualine')
        end
    },
    {
        'numToStr/Comment.nvim',
        opts = {}
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        opts = {
            char = '┊',
            show_trailing_blankline_indent = false,
        },
    },
    {
        'nvim-telescope/telescope.nvim',
        version = '*',
        dependencies = {
            'nvim-lua/plenary.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
                config = function ()
                    pcall(require('telescope').load_extension, 'fzf')
                end
            },
        },
        config = function()
            require('plugins/telescope')
        end
    },
    {
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        config = function()
            pcall(require('nvim-treesitter.install').update { with_sync = true })
            require('plugins/treesitter')
        end,
    },
    {
        'goolord/alpha-nvim',
        dependencies = {
            'kyazdani42/nvim-web-devicons'
        },
        config = function()
            require('alpha').setup(require('alpha.themes.dashboard').config)
        end
    },
    {
        'Raimondi/delimitMate',
        event = "InsertEnter"
    },
    {
        'simrat39/rust-tools.nvim',
        dependencies = {
            'nvim-lspconfig'
        },
        config = function()
            require('plugins/rust-tools')
        end
    }
})

