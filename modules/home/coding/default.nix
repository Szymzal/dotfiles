{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.mypackages.coding;
in
{
  options = {
    mypackages.coding = {
      enable = mkEnableOption "Enable text editor for coding";
    };
  };

  config = mkIf cfg.enable {
    stylix.targets.vim.enable = mkIf (config.mypackages.theme.enable) false;

    # copied from: https://github.com/LazyVim/LazyVim/discussions/1972
    programs.neovim = {
      enable = true;

      viAlias = true;
      vimAlias = true;

      extraPackages = (with pkgs; [
        # LazyVim
        lua-language-server
        stylua
        lazygit

        # Telescope
        ripgrep
        fd

        # LSPs
        rust-analyzer
        gopls
        nil
        lua-language-server
        taplo
        gleam
        vscode-langservers-extracted
        nodePackages."@astrojs/language-server"
        nodePackages.typescript-language-server
        nodePackages.intelephense
        myNodePackages."@spyglassmc/language-server"

        # Neorg
        luajit

        # Golang
        delve
        gomodifytags
        impl
        gofumpt
      ]);

      plugins = with pkgs.vimPlugins; [
        lazy-nvim
      ];

      extraLuaConfig =
        let
          plugins = with pkgs.vimPlugins; [
            # colorscheme
            edge

            # LazyVim
            LazyVim
            bufferline-nvim
            cmp-buffer
            cmp-nvim-lsp
            cmp-path
            cmp_luasnip
            conform-nvim
            dashboard-nvim
            dressing-nvim
            flash-nvim
            friendly-snippets
            gitsigns-nvim
            indent-blankline-nvim
            lazydev-nvim
            lualine-nvim
            { name = "luvit-meta"; path = luvit-meta; }
            neo-tree-nvim
            neoconf-nvim
            neodev-nvim
            noice-nvim
            nui-nvim
            nvim-snippets
            nvim-cmp
            nvim-lint
            nvim-lspconfig
            nvim-notify
            nvim-spectre
            nvim-treesitter
            nvim-treesitter-context
            nvim-treesitter-textobjects
            nvim-ts-autotag
            nvim-ts-context-commentstring
            nvim-web-devicons
            persistence-nvim
            plenary-nvim
            telescope-fzf-native-nvim
            telescope-nvim
            todo-comments-nvim
            tokyonight-nvim
            trouble-nvim
            vim-illuminate
            vim-startuptime
            which-key-nvim
            { name = "grug-far.nvim"; path = grug-far-nvim; }
            { name = "ts-comments.nvim"; path = ts-comments-nvim; }
            { name = "LuaSnip"; path = luasnip; }
            { name = "catppuccin"; path = catppuccin-nvim; }
            { name = "mini.ai"; path = mini-nvim; }
            { name = "mini.bufremove"; path = mini-nvim; }
            { name = "mini.comment"; path = mini-nvim; }
            { name = "mini.indentscope"; path = mini-nvim; }
            { name = "mini.pairs"; path = mini-nvim; }
            { name = "mini.surround"; path = mini-nvim; }
            { name = "mini.icons"; path = mini-nvim; }

            # rust plugin
            crates-nvim
            neotest
            rustaceanvim

            # go plugin
            neotest-go
            nvim-dap-go

            # ORG
            neorg
            { name = "luarocks.nvim"; path = luarocks-nvim; }
            lua-utils-nvim
            pathlib-nvim
            nvim-nio
          ] ++ lib.optionals (config.mypackages.theme.enable) [
            { name = "mini.base16"; path = mini-nvim; }
          ];

          mkEntryFromDrv = drv:
            if lib.isDerivation drv then
              { name = "${lib.getName drv}"; path = drv; }
            else
              drv;

          lazyPath = pkgs.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);
        in
        ''
          require("lazy").setup({
            defaults = {
              lazy = true,
            },
            dev = {
              -- reuse files from pkgs.vimPlugins.*
              path = "${lazyPath}",
              patterns = { "." },
              -- fallback to download
              fallback = true,
            },
            spec = {
              { "LazyVim/LazyVim", import = "lazyvim.plugins" },
              -- The following configs are needed for fixing lazyvim on nix
              -- force enable telescope-fzf-native.nvim
              { "nvim-telescope/telescope-fzf-native.nvim", enabled = true },
              -- disable mason.nvim, use programs.neovim.extraPackages
              { "williamboman/mason-lspconfig.nvim", enabled = false },
              { "williamboman/mason.nvim", enabled = false },
              -- import rust plugin
              { import = "lazyvim.plugins.extras.lang.rust" },
              -- import go plugin
              { import = "lazyvim.plugins.extras.lang.go" },
              -- import/override with your plugins
              { import = "extensions" },
              { import = "plugins" },
              -- treesitter handled by xdg.configFile."nvim/parser", put this line at the end of spec to clear ensure_installed
              { "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = {} } },
            },
          })
        '';
    };

    home.file = {
      ".config/nvim/parser".source =
        let
          parsers = pkgs.symlinkJoin {
            name = "treesitter-parsers";
            paths = (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: with plugins; [
              tree-sitter-bash
              tree-sitter-html
              tree-sitter-javascript
              tree-sitter-typescript
              tree-sitter-json
              tree-sitter-lua
              tree-sitter-markdown
              tree-sitter-markdown-inline
              tree-sitter-python
              tree-sitter-query
              tree-sitter-regex
              tree-sitter-vim
              tree-sitter-vimdoc
              tree-sitter-yaml
              tree-sitter-toml
              tree-sitter-css
              tree-sitter-c
              tree-sitter-cpp
              tree-sitter-rust
              tree-sitter-nix
              tree-sitter-php
              tree-sitter-go
              tree-sitter-gomod
              tree-sitter-gowork
              tree-sitter-gosum
              tree-sitter-norg
              tree-sitter-norg-meta
              tree-sitter-gleam
            ])).dependencies;
          };
        in
        "${parsers}/parser";

      ".config/nvim/lua/config".source = ./config/nvim/lua/config;
      ".config/nvim/lua/plugins".source = ./config/nvim/lua/plugins;
      ".config/nvim/lua/extensions/core.lua".text = mkIf (config.mypackages.theme.enable) ''
        return {
          {
            "echasnovski/mini.base16",
            priority = 1000,
            lazy = false,
            config = function()
              require('mini.base16').setup({
                palette = {
                  base00 = "#${config.lib.stylix.colors.base00}",
                  base01 = "#${config.lib.stylix.colors.base01}",
                  base02 = "#${config.lib.stylix.colors.base02}",
                  base03 = "#${config.lib.stylix.colors.base03}",
                  base04 = "#${config.lib.stylix.colors.base04}",
                  base05 = "#${config.lib.stylix.colors.base05}",
                  base06 = "#${config.lib.stylix.colors.base06}",
                  base07 = "#${config.lib.stylix.colors.base07}",
                  base08 = "#${config.lib.stylix.colors.base08}",
                  base09 = "#${config.lib.stylix.colors.base09}",
                  base0A = "#${config.lib.stylix.colors.base0A}",
                  base0B = "#${config.lib.stylix.colors.base0B}",
                  base0C = "#${config.lib.stylix.colors.base0C}",
                  base0D = "#${config.lib.stylix.colors.base0D}",
                  base0E = "#${config.lib.stylix.colors.base0E}",
                  base0F = "#${config.lib.stylix.colors.base0F}",
                },
                use_cterm = true,
                plugins = { default = true },
              })
            end
          },
        }
      '';
    };

    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "intelephense"
      ];
  };
}
