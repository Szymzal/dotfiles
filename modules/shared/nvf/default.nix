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
      lspSignature.enable = true;
      otter-nvim.enable = true;
      lsplines.enable = true;
    };

    languages = {
      enableLSP = true;
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
      };
    };

    visuals = {
      nvim-web-devicons.enable = true;
      nvim-cursorline.enable = false;
      fidget-nvim.enable = true;

      highlight-undo.enable = true;
      indent-blankline.enable = true;
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

    # FIX: nvim-cmp cannot find luasnip module?
    autocomplete.nvim-cmp = {
      enable = true;
      mappings = {
        next = "<C-n>";
        previous = "<C-p>";
      };
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
      whichKey.enable = false;
      cheatsheet.enable = false;
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
      motion = {
        hop.enable = false;
        leap.enable = false;
        precognition.enable = false;
      };
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
