{
  pkgs,
  lib,
}: {
  config.vim =
    {
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
        java.enable = false;
        dart = {
          enable = true;
          flutter-tools = {
            enable = true;
          };
        };
        vala.enable = true;
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

      session.nvim-session-manager.enable = false;

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
        project-nvim.enable = false;
      };

      utility = {
        surround.enable = true;
        images.image-nvim.enable = false;
        oil-nvim.enable = true;
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
          key = "-";
          mode = "n";
          desc = "Open Oil";
          action = "<CMD>Oil<CR>";
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
        # Misc
        {
          key = "<C-i>";
          mode = "n";
          desc = "Finish search";
          action = "<CMD>noh<CR>";
        }
      ];
    }
    // (with lib; let
      inherit (builtins) hasAttr head throw typeOf isList isAttrs isBool isInt isString isPath isFloat toJSON;
      inherit (lib.generators) mkLuaInline;
      inherit (lib.strings) hasSuffix;

      # copied from: https://github.com/NotAShelf/nvf/blob/main/lib/lua.nix
      isLuaInline = object: (object._type or null) == "lua-inline";

      # copied from: https://github.com/NotAShelf/nvf/blob/main/lib/lua.nix
      toLuaObject = args:
        if isAttrs args
        then
          if isLuaInline args
          then args.expr
          else if hasAttr "__empty" args
          then
            warn ''
              Using `__empty` to define an empty lua table is deprecated. Use an empty attrset instead.
            '' "{ }"
          else
            "{"
            + (concatStringsSep ","
              (mapAttrsToList
                (n: v:
                  if head (stringToCharacters n) == "@"
                  then toLuaObject v
                  else "[${toLuaObject n}] = " + (toLuaObject v))
                (filterAttrs
                  (_: v: v != null)
                  args)))
            + "}"
        else if isList args
        then "{" + concatMapStringsSep "," toLuaObject args + "}"
        else if isString args
        then
          # This should be enough!
          toJSON args
        else if isPath args
        then toJSON (toString args)
        else if isBool args
        then "${boolToString args}"
        else if isFloat args
        then "${toString args}"
        else if isInt args
        then "${toString args}"
        else if (args == null)
        then "nil"
        else throw "could not convert object of type `${typeOf args}` to lua object";

      vscode-java-debug = "${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug";
      vscode-java-test = "${pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-java-test";
          publisher = "vscjava";
          version = "0.43.0";
          sha256 = "sha256-EM0S1Y4cRMBCRbAZgl9m6fIhANPrvdGVZXOLlDLnVWo=";
        };
      }}/share/vscode/extensions/vscjava.vscode-java-test";

      getJars = plugin:
        map
        (jar: "${plugin}/server/${jar}")
        (builtins.attrNames (builtins.readDir "${plugin}/server"));

      bundles = toLuaObject (
        builtins.filter
        # https://github.com/mfussenegger/nvim-jdtls/issues/746
        (jar: !(hasSuffix "com.microsoft.java.test.runner-jar-with-dependencies.jar" jar || hasSuffix "jacocoagent.jar" jar))
        (builtins.concatLists [
          (getJars vscode-java-debug)
          (getJars vscode-java-test)
        ])
      );

      settings = {
        java = {
          completion.enabled = true;
          configuration.runtimes = [
            {
              name = "JavaSE-11";
              path = "${pkgs.jdk11}";
            }
            {
              name = "JavaSE-17";
              path = "${pkgs.jdk17}";
              default = true;
            }
            {
              name = "JavaSE-21";
              path = "${pkgs.jdk21}";
            }
          ];
          contentProvider.preferred = "fernflower";
          eclipse.downloadSources = true;
          inlayHints.parameterNames.enabled = "all";
          signatureHelp.enabled = true;
          sources = {
            organizeImports = {
              starThreshold = 9999;
              staticStarThreshold = 9999;
            };
          };
        };
      };
    in {
      autocmds = [
        {
          callback =
            mkLuaInline
            # lua
            ''
              function()
                local jdtls = require("jdtls")

                local root_dir = jdtls.setup.find_root({ "mvnw", "gradlew", ".git" })

                local cmd = {
                  "${lib.getExe pkgs.jdt-language-server}",
                  "--jvm-arg=-javaagent:${pkgs.lombok}/share/java/lombok.jar",
                  "-configuration",
                  vim.fn.stdpath("cache") .. "/jdtls/config",
                  "-data",
                  vim.fn.stdpath("cache") .. "/jdtls/workspace/" .. vim.fn.fnamemodify(root_dir, ":p:h:t"),
                }

                local on_attach = function(_, bufnr)
                  vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

                  -- https://github.com/microsoft/vscode-java-debug/blob/main/src/launchCommand.ts#L27
                  local overrides = { shortenCommandLine = "argfile" }
                end

                local init_options = {
                  bundles = ${bundles},
                  extendedClientCapabilities = vim.tbl_extend(
                    "force",
                    {},
                    jdtls.extendedClientCapabilities,
                    { resolveAdditionalTextEditsSupport = true }
                  ),
                }

                jdtls.start_or_attach({
                  capabilities = capabilities,
                  cmd = cmd,
                  on_attach = on_attach,
                  init_options = init_options,
                  root_dir = root_dir,
                  settings = ${toLuaObject settings},
                })
              end
            '';
          desc = "jdtls start autocmd";
          event = ["FileType"];
          pattern = ["java"];
        }
      ];

      extraPlugins."jdtls".package = pkgs.vimPlugins.nvim-jdtls;
    });
}
