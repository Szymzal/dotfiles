{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
with lib; let
  cfg = config.mypackages.coding;
in {
  options = {
    mypackages.coding = {
      enable = mkEnableOption "Enable text editor for coding";
    };
  };

  config = mkIf cfg.enable {
    stylix.targets.vim.enable = mkIf config.mypackages.theme.enable false;
    stylix.targets.neovim.enable = mkIf config.mypackages.theme.enable false;

    home.packages = [
      (
        inputs.nvf.lib.neovimConfiguration {
          inherit pkgs;
          modules = [../../shared/nvf];
        }
      )
      .neovim
    ];

    # nixd
    nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

    # copied from: https://github.com/LazyVim/LazyVim/discussions/1972
    # programs.neovim = {
    #   enable = true;
    #
    #   viAlias = true;
    #   vimAlias = true;
    #
    #   defaultEditor = true;
    #
    #   extraPackages = with pkgs; [
    #     # LazyVim
    #     lua-language-server
    #     stylua
    #     lazygit
    #     fzf
    #
    #     # Telescope
    #     ripgrep
    #     fd
    #
    #     # LSPs
    #     rust-analyzer
    #     gopls
    #     nixd
    #     lua-language-server
    #     taplo
    #     gleam
    #     vscode-langservers-extracted
    #     nodePackages."@astrojs/language-server"
    #     # TODO: Update?
    #     nodePackages.typescript-language-server
    #     nodePackages.intelephense
    #     myNodePackages."@spyglassmc/language-server"
    #
    #     # Golang
    #     delve
    #     gomodifytags
    #     impl
    #     gofumpt
    #
    #     # Formaters
    #     alejandra
    #   ];
    #
    #   plugins = with pkgs.vimPlugins; [
    #     lazy-nvim
    #   ];
    #
    #   extraLuaConfig = let
    #     plugins = with pkgs.vimPlugins;
    #       [
    #         # colorscheme
    #         edge
    #
    #         # LazyVim
    #         LazyVim
    #         bufferline-nvim
    #         blink-cmp
    #         conform-nvim
    #         flash-nvim
    #         friendly-snippets
    #         fzf-lua
    #         gitsigns-nvim
    #         lazydev-nvim
    #         lualine-nvim
    #         neo-tree-nvim
    #         noice-nvim
    #         nui-nvim
    #         nvim-lint
    #         nvim-lspconfig
    #         nvim-treesitter
    #         nvim-treesitter-textobjects
    #         nvim-ts-autotag
    #         persistence-nvim
    #         plenary-nvim
    #         snacks-nvim
    #         telescope-fzf-native-nvim
    #         todo-comments-nvim
    #         tokyonight-nvim
    #         trouble-nvim
    #         which-key-nvim
    #         {
    #           name = "grug-far.nvim";
    #           path = grug-far-nvim;
    #         }
    #         {
    #           name = "ts-comments.nvim";
    #           path = ts-comments-nvim;
    #         }
    #         {
    #           name = "LuaSnip";
    #           path = luasnip;
    #         }
    #         {
    #           name = "catppuccin";
    #           path = catppuccin-nvim;
    #         }
    #         {
    #           name = "mini.ai";
    #           path = mini-nvim;
    #         }
    #         {
    #           name = "mini.pairs";
    #           path = mini-nvim;
    #         }
    #         {
    #           name = "mini.icons";
    #           path = mini-nvim;
    #         }
    #
    #         # rust plugin
    #         crates-nvim
    #         rustaceanvim
    #       ]
    #       ++ lib.optionals (config.mypackages.theme.enable) [
    #         {
    #           name = "mini.base16";
    #           path = mini-nvim;
    #         }
    #       ];
    #
    #     mkEntryFromDrv = drv:
    #       if lib.isDerivation drv
    #       then {
    #         name = "${lib.getName drv}";
    #         path = drv;
    #       }
    #       else drv;
    #
    #     lazyPath = pkgs.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);
    #   in ''
    #     require("lazy").setup({
    #       defaults = {
    #         lazy = true,
    #       },
    #       dev = {
    #         -- reuse files from pkgs.vimPlugins.*
    #         path = "${lazyPath}",
    #         patterns = { "." },
    #         -- fallback to download
    #         fallback = true,
    #       },
    #       spec = {
    #         { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    #         -- The following configs are needed for fixing lazyvim on nix
    #         -- force enable telescope-fzf-native.nvim
    #         { "nvim-telescope/telescope-fzf-native.nvim", enabled = true },
    #         -- disable mason.nvim, use programs.neovim.extraPackages
    #         { "williamboman/mason-lspconfig.nvim", enabled = false },
    #         { "williamboman/mason.nvim", enabled = false },
    #         -- import rust plugin
    #         { import = "lazyvim.plugins.extras.lang.rust" },
    #         -- import go plugin
    #         { import = "lazyvim.plugins.extras.lang.go" },
    #         -- import/override with your plugins
    #         { import = "extensions" },
    #         { import = "plugins" },
    #         -- treesitter handled by xdg.configFile."nvim/parser", put this line at the end of spec to clear ensure_installed
    #         { "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = {} } },
    #       },
    #     })
    #   '';
    # };

    # home.file = {
    #   ".config/nvim/parser".source = let
    #     parsers = pkgs.symlinkJoin {
    #       name = "treesitter-parsers";
    #       paths =
    #         (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins:
    #           with plugins; [
    #             tree-sitter-bash
    #             tree-sitter-html
    #             tree-sitter-javascript
    #             tree-sitter-typescript
    #             tree-sitter-json
    #             tree-sitter-lua
    #             tree-sitter-markdown
    #             tree-sitter-markdown-inline
    #             tree-sitter-python
    #             tree-sitter-query
    #             tree-sitter-regex
    #             tree-sitter-vim
    #             tree-sitter-vimdoc
    #             tree-sitter-yaml
    #             tree-sitter-toml
    #             tree-sitter-css
    #             tree-sitter-c
    #             tree-sitter-cpp
    #             tree-sitter-rust
    #             tree-sitter-nix
    #             tree-sitter-php
    #             tree-sitter-go
    #             tree-sitter-gomod
    #             tree-sitter-gowork
    #             tree-sitter-gosum
    #             tree-sitter-gleam
    #           ]))
    #         .dependencies;
    #     };
    #   in "${parsers}/parser";
    #
    #   ".config/nvim/lua/config".source = ./config/nvim/lua/config;
    #   ".config/nvim/lua/plugins".source = ./config/nvim/lua/plugins;
    #   ".config/nvim/lua/extensions/completion.lua".text = ''
    #     return {
    #     	{
    #     		"saghen/blink.cmp",
    #     		opts = {
    #     			fuzzy = {
    #     				prebuilt_binaries = {
    #     					download = false,
    #     					force_version = "${pkgs.vimPlugins.blink-cmp.version}",
    #     				},
    #     			},
    #     		},
    #     	},
    #     }
    #   '';
    #   ".config/nvim/lua/extensions/core.lua".text = mkIf (config.mypackages.theme.enable) ''
    #     return {
    #       {
    #         "echasnovski/mini.base16",
    #         priority = 1000,
    #         lazy = false,
    #         config = function()
    #           require('mini.base16').setup({
    #             palette = {
    #               base00 = "#${config.lib.stylix.colors.base00}",
    #               base01 = "#${config.lib.stylix.colors.base01}",
    #               base02 = "#${config.lib.stylix.colors.base02}",
    #               base03 = "#${config.lib.stylix.colors.base03}",
    #               base04 = "#${config.lib.stylix.colors.base04}",
    #               base05 = "#${config.lib.stylix.colors.base05}",
    #               base06 = "#${config.lib.stylix.colors.base06}",
    #               base07 = "#${config.lib.stylix.colors.base07}",
    #               base08 = "#${config.lib.stylix.colors.base08}",
    #               base09 = "#${config.lib.stylix.colors.base09}",
    #               base0A = "#${config.lib.stylix.colors.base0A}",
    #               base0B = "#${config.lib.stylix.colors.base0B}",
    #               base0C = "#${config.lib.stylix.colors.base0C}",
    #               base0D = "#${config.lib.stylix.colors.base0D}",
    #               base0E = "#${config.lib.stylix.colors.base0E}",
    #               base0F = "#${config.lib.stylix.colors.base0F}",
    #             },
    #             use_cterm = true,
    #             plugins = { default = true },
    #           })
    #         end
    #       },
    #     }
    #   '';
    # };
  };
}
