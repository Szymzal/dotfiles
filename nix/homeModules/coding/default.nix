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
      ];

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
            lualine-nvim
            neo-tree-nvim
            neoconf-nvim
            neodev-nvim
            noice-nvim
            nui-nvim
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
            rust-tools-nvim
            neotest-rust

            suda-vim
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
              { "lazyvim.plugins.extra.lang.rust" },
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
            ])).dependencies;
          };
        in
        "${parsers}/parser";

      ".config/nvim/lua".source = ./config/nvim/lua;
    };
  };
}
