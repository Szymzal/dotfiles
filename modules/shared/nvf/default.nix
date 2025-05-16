{
  config.vim = {
    viAlias = true;
    vimAlias = true;

    lazy.enable = true;

    options = {
      shiftwidth = 2;
      tabstop = 2;
      wrap = false;
    };

    lsp = {
      enable = true;
      formatOnSave = true;
      lightbulb.enable = true;
      trouble.enable = true;
      otter-nvim.enable = true;
    };

    languages = {
      enableFormat = true;
      enableTreesitter = true;
      enableExtraDiagnostics = true;

      nix.enable = true;
      markdown = {
        enable = true;
        extensions.render-markdown-nvim.enable = true;
      };

      bash.enable = true;
      css.enable = true;
      html = {
        enable = true;
        treesitter.enable = true;
      };
      ts.enable = true;
      go.enable = true;
      lua.enable = true;
      python.enable = true;
      php.enable = true;
      wgsl.enable = true;
      rust = {
        enable = true;
        crates.enable = true;
        dap.enable = true;
      };
      java.enable = true;
      dart = {
        enable = true;
        flutter-tools = {
          enable = true;
        };
      };
    };

    debugger = {
      nvim-dap = {
        enable = true;
        ui.enable = true;
      };
    };

    visuals = {
      nvim-web-devicons.enable = true;
      fidget-nvim.enable = true;

      indent-blankline.enable = true;
      nvim-cursorline.enable = true;
    };

    statusline = {
      lualine = {
        enable = true;
        theme = "catppuccin";
      };
    };

    theme = {
      enable = true;
      name = "catppuccin";
      style = "mocha";
      transparent = false;
    };

    autopairs.nvim-autopairs.enable = true;

    autocomplete.blink-cmp = {
      enable = true;
      mappings = {
        next = "<C-n>";
        previous = "<C-p>";
      };
      setupOpts.signature.enabled = true;
    };
    snippets.luasnip.enable = true;

    filetree = {
      neo-tree = {
        enable = true;
      };
    };

    tabline = {
      nvimBufferline = {
        enable = true;
        mappings = {
          closeCurrent = "<leader>bd";
          cycleNext = "<S-l>";
          cyclePrevious = "<S-h>";
        };
      };
    };

    treesitter.context.enable = true;

    binds = {
      whichKey.enable = true;
      cheatsheet.enable = true;
    };

    telescope.enable = true;

    git = {
      enable = true;
      gitsigns.enable = true;
      gitsigns.codeActions.enable = false;
    };

    dashboard = {
      alpha.enable = true;
    };

    notify = {
      nvim-notify.enable = true;
    };

    projects = {
      project-nvim.enable = true;
    };

    utility = {
      surround.enable = true;
      images.image-nvim.enable = false;
    };

    notes = {
      todo-comments.enable = true;
    };

    terminal = {
      toggleterm = {
        enable = true;
        lazygit.enable = true;
      };
    };

    ui = {
      borders.enable = true;
      noice.enable = true;
      colorizer.enable = true;
      illuminate.enable = true;
      breadcrumbs = {
        enable = true;
        navbuddy.enable = true;
      };
      smartcolumn = {
        enable = true;
      };
      fastaction.enable = true;
    };

    comments = {
      comment-nvim.enable = true;
    };

    keymaps = [
      {
        key = "<leader>e";
        mode = "n";
        silent = true;
        desc = "Open NeoTree";
        action = ":Neotree<CR>";
      }
      # Windows
      {
        key = "<C-h>";
        mode = "n";
        desc = "Go to Left Window";
        action = "<C-w>h";
      }
      {
        key = "<C-j>";
        mode = "n";
        desc = "Go to Lower Window";
        action = "<C-w>j";
      }
      {
        key = "<C-k>";
        mode = "n";
        desc = "Go to Upper Window";
        action = "<C-w>k";
      }
      {
        key = "<C-l>";
        mode = "n";
        desc = "Go to Right Window";
        action = "<C-w>l";
      }
    ];
  };
}
