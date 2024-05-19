{ pkgs, lib, config, inputs, ... }:
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
    home.packages = with pkgs; [
      gnumake
    ];

    programs.neovim = {
      enable = true;

      viAlias = true;
      vimAlias = true;

      extraPackages = with pkgs; [
        # LazyVim
        lua-language-server
        stylua
        lazygit

        # Telescope
        ripgrep
        fd

        # LSPs
        rust-analyzer
        nil
        lua-language-server
        taplo
        vscode-langservers-extracted
        # nodePackages.@astrojs/language-server
        nodePackages.typescript-language-server
        nodePackages.intelephense

        # Neorg
        luajit
      ];

      plugins = with pkgs.vimPlugins; [
        lazy-nvim
      ];

      extraLuaConfig =
        let
          nvim-snippets = pkgs.vimUtils.buildVimPlugin {
            pname = "nvim-snippets";
            version = "2024-05-19";
            src = inputs.nvim-snippets;
          };

          lua-utils-nvim = pkgs.vimUtils.buildVimPlugin {
            inherit (pkgs.luajitPackages.lua-utils-nvim) pname version src;
          };

          pathlib-nvim = pkgs.vimUtils.buildVimPlugin {
            inherit (pkgs.luajitPackages.pathlib-nvim) pname version src;
          };

          luarocks-nvim = pkgs.vimUtils.buildVimPlugin {
            name = "luarocks.nvim";
            version = "2024-05-19";
            src = inputs.luarocks-nvim;
          };

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
            lualine-nvim
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
            { name = "LuaSnip"; path = luasnip; }
            { name = "catppuccin"; path = catppuccin-nvim; }
            { name = "mini.ai"; path = mini-nvim; }
            { name = "mini.bufremove"; path = mini-nvim; }
            { name = "mini.comment"; path = mini-nvim; }
            { name = "mini.indentscope"; path = mini-nvim; }
            { name = "mini.pairs"; path = mini-nvim; }
            { name = "mini.surround"; path = mini-nvim; }

            # rust plugin
            crates-nvim
            neotest
            rustaceanvim

            # ORG
            neorg
            { name = "luarocks.nvim"; path = luarocks-nvim; }
            lua-utils-nvim
            pathlib-nvim
            nvim-nio
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
              -- import/override with your plugins
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
              bash
              html
              javascript
              typescript
              json
              lua
              markdown
              markdown_inline
              python
              query
              regex
              vim
              yaml
              toml
              css
              c
              cpp
              rust
              nix
              php
            ] ++ (with pkgs.tree-sitter-grammars; [
              tree-sitter-norg
              tree-sitter-norg-meta
            ]))).dependencies;
          };
        in
        "${parsers}/parser";

      ".config/nvim/lua".source = ./config/nvim/lua;
    };

    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "intelephense"
      ];
  };
}
