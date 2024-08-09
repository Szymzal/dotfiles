{ inputs, pkgs, lib, config, osConfig, ... }:
with lib;
let
  myLib = osConfig.lib.myLib;
in
{
  imports = [
    inputs.hyprland.homeManagerModules.default
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  options = {
    mypackages = {
      wm = {
        enable = mkEnableOption "Enable window manager";
        wallpaper-path = mkOption {
          default = null;
          example = literalExpression ''
            /persist/nixos/wallpaper.png
          '';
          description = "Path to wallpaper (support for: png, jpg, jpeg, webp)";
          type = types.path;
        };
        splash = mkOption {
          default = false;
          example = "true";
          description = "Enable splashes on screens";
          type = types.bool;
        };
      };

      viewers = {
        enableAll = mkEnableOption "Enable all viewers";
        video = {
          enable = mkEnableOption "Enable video viewer";
        };
        image = {
          enable = mkEnableOption "Enable image viewer";
        };
      };

      video-editing = {
        enable = mkEnableOption "Enable video editing program";
      };

      video-recording = {
        enable = mkEnableOption "Enable video recording";
      };

      tmux = {
        enable = mkEnableOption "Enable tmux";
      };

      theme = {
        enable = mkEnableOption "Enable theming";
        prefer-dark-theme = mkOption {
          default = true;
          example = false;
          description = "Prefer dark theme on applications";
          type = types.bool;
        };
        theme = {
          base16-scheme-path = mkOption {
            default = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
            example = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
          };
        };
        cursorTheme = {
          name = mkOption {
            default = "Catppuccin-Mocha-Dark-Cursors";
            example = "Catppuccin-Mocha-Dark-Cursors";
            description = "Name of gtk cursor theme";
            type = types.str;
          };
          size = mkOption {
            default = 24;
            example = 48;
            description = "Size of cursor";
            type = types.ints.unsigned;
          };
          package = mkOption {
            default = pkgs.catppuccin-cursors.mochaDark;
            example = literalExpression ''
              pkgs.catppuccin-cursors.mochaDark
            '';
            description = "Package of gtk cursor theme";
            type = types.package;
          };
          hyprcursor = {
            enable = mkEnableOption "Enable hyprcursor";
            name = mkOption {
              default = "Bibata-Modern-Classic-hyprcursor";
            };
            package = mkOption {
              default = pkgs.bibata-hyprcursor;
              example = literalExpression ''
                pkgs.bibata-hyprcursor
              '';
              description = "Package for hyprcursor";
              type = types.package;
            };
          };
        };
        iconTheme = {
          name = mkOption {
            default = "Papirus";
            example = "Papirus";
            description = "Name of gtk icon theme";
            type = types.str;
          };
          package = mkOption {
            default = pkgs.papirus-icon-theme;
            example = literalExpression ''
              pkgs.papirus-icon-theme
            '';
            description = "Package of gtk icon theme";
            type = types.package;
          };
        };
      };

      terminal = {
        enable = mkEnableOption "Enable terminal";
      };

      status-bar = {
        enable = mkEnableOption "Enable status bar";
      };

      screenshot = {
        enable = mkEnableOption "Enable screenshotting tool";
        savePicturesPath = mkOption {
          default = "Pictures/Screenshots";
          example = "Pictures/Screenshots";
          description = "Path to directory for screenshots (only in /home/{user} directory)";
          type = types.str;
        };
      };

      office = {
        enable = mkEnableOption "Enable Office suite";
      };

      notifications = {
        enable = mkEnableOption "Enable notification deamon";
      };

      notes = {
        enable = mkEnableOption "Enable note taking app";
      };

      ls = {
        enable = mkEnableOption "Enable ls replacement";
      };

      ldtk = {
        enable = mkEnableOption "Enable LDTK";
      };

      launcher = {
        enable = mkEnableOption "Enable App/Power launcher";
      };

      impermanence = {
        enable = mkEnableOption "Enable impermanence";
        persistent-path = mkOption {
          default = "${osCfg.persistenceDir}/home";
          example = "/persist/home/szymzal";
          description = "Path to persist all folders";
          type = types.str;
        };
        directories = mkOption {
          default = [];
          example = [ "Downloads" "dev/project" ];
          description = "Directories to persist. Directories will be appended to persistent-path option";
          type = types.listOf (types.either types.str types.attrs );
        };
        files = mkOption {
          default = [];
          example = [ ".zshrc" ".ssh/id_rsa" ];
          description = "Files to persist. File paths will be appended to persistent-path option";
          type = types.listOf types.str;
        };
      };

      image-editors = {
        enable = mkEnableOption "Enable file explorer";
      };

      git = {
        enable = mkEnableOption "Enable git";
        userName = mkOption {
          default = null;
          example = "Szymzal";
          description = "Username of git user";
          type = types.str;
        };
        userEmail = mkOption {
          default = null;
          example = "szymzal05@gmail.com";
          description = "Email of git user";
          type = types.str;
        };
      };

      find = {
        enable = mkEnableOption "Enable find replacement";
      };

      file-explorer = {
        enable = mkEnableOption "Enable file explorer";
      };

      communication = {
        enable = mkEnableOption "Enable communication app (e.g. discord)";
      };

      cd = {
        enable = mkEnableOption "Enable cd replacement";
      };

      casparcg-client = {
        enable = mkEnableOption "Enable CasparCG Client";
      };

      calendar = {
        enable = mkEnableOption "Enable cd replacement";
      };

      browser = {
        enable = mkEnableOption "Enable browser";
      };

      bottles = {
        enable = mkEnableOption "Enable bottles";
      };
    };
  };

  config = mkMerge [

    (let
      cfg = config.mypackages.wm;
    in
    (mkIf cfg.enable
      (let
        power-menu-script = pkgs.writeShellScriptBin "power-menu" ''
          killall wlogout || ${pkgs.wlogout}/bin/wlogout
        '';
        screenshot-script = pkgs.writeShellScriptBin "screenshot" ''
          ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -o -r -c '#ff0000ff')" - | ${pkgs.satty}/bin/satty --filename - --fullscreen --output-filename ~/${config.mypackages.screenshot.savePicturesPath}/$(date '+%Y%m%d-%H:%M:%S').png
        '';
        fakefullscreen-script = pkgs.writeShellScriptBin "fakefullscreen" ''
          hyprctl dispatch -- setfloating
          hyprctl dispatch -- resizeactive exact 100% 100%
          hyprctl dispatch -- centerwindow
          sleep 1
          hyprctl dispatch -- fullscreen
        '';
        monitors = osConfig.mypackages.monitors;
      in
      {
        assertions = [
          {
            assertion = ((builtins.head monitors) != []);
            message = "Please specify mypackages.monitors in nixos configuration!";
          }
        ];

        mypackages = {
          terminal.enable = mkDefault true;
          status-bar.enable = mkDefault true;
          launcher.enable = mkDefault true;
          notifications.enable = mkDefault true;
        };

        home.packages = with pkgs; [
          killall
          pamixer
          hyprpaper
          wlogout
          bibata-hyprcursor
        ];

        wayland.windowManager.hyprland = {
          enable = true;

          settings = {
            exec-once = [
              "hyprpaper"
              "waybar"
              "ags"
            ] ++ lib.optionals (config.mypackages.theme.cursorTheme.hyprcursor.enable) [
              "hyprctl setcursor ${config.mypackages.theme.cursorTheme.hyprcursor.name} ${builtins.toString config.mypackages.theme.cursorTheme.size}"
            ];

            input = {
              kb_layout = "pl";
            };

            debug = {
              disable_logs = false;
            };

            misc = {
              disable_hyprland_logo = true;
              layers_hog_keyboard_focus = true;
              mouse_move_focuses_monitor = true;
            };

            cursor = {
              # Cursor behavies really weird and can crash Hyprland. Don't touch it until https://github.com/hyprwm/Hyprland/issues/5776
              # It also includes WLR_NO_HARDWARE_CURSORS on dm.nix
              no_hardware_cursors = mkIf (osConfig.mypackages.nvidia.enable && osConfig.mypackages.nvidia.open.enable) true;
              default_monitor = "${myLib.getPrimaryMonitor.connector}";
            };

            "$terminal" = "kitty";
            "$mod" = "SUPER";

            env = [
              "XDG_SESSION_TYPE,wayland"
              "NIXOS_OZONE_WL,1"
              "XCURSOR_THEME,${config.mypackages.theme.cursorTheme.name}"
              "XCURSOR_SIZE,${builtins.toString config.mypackages.theme.cursorTheme.size}"
            ] ++ lib.optionals (osConfig.mypackages.nvidia.enable && !osConfig.mypackages.nvidia.open.enable) [
              "LIBVA_DRIVER_NAME,nvidia"
            ] ++ lib.optionals config.mypackages.browser.enable [
              "MOZ_ENABLE_WAYLAND,1"
            ] ++ lib.optionals (osConfig.mypackages.nvidia.enable && osConfig.mypackages.nvidia.open.enable) [
              "WLR_NO_HARDWARE_CURSORS,1"
            ] ++ lib.optionals (config.mypackages.theme.cursorTheme.hyprcursor.enable) [
              "HYPRCURSOR_THEME,${config.mypackages.theme.cursorTheme.hyprcursor.name}"
              "HYPRCURSOR_SIZE,${builtins.toString config.mypackages.theme.cursorTheme.size}"
            ];

            monitor = (myLib.hyprlandMonitorsConfig);
            workspace = [
              "1,monitor:${myLib.getPrimaryMonitor.connector},default:true"
            ];

            bind = [
              "$mod, Return, exec, $terminal"
              "$mod, C, killactive"
              "$mod SHIFT, C, exec, hyprctl kill"
              "$mod, M, exit"
              "$mod, Space, togglefloating"

              "$mod, F, fullscreen"
              "$mod SHIFT, F, exec, ${fakefullscreen-script}/bin/fakefullscreen"

              "$mod, E, exec, killall bemoji || bemoji"
              "$mod, D, exec, killall fuzzel || fuzzel"
              "$mod, Q, exec, ${power-menu-script}/bin/power-menu"

              "$mod, H, movefocus, l"
              "$mod, L, movefocus, r"
              "$mod, K, movefocus, u"
              "$mod, J, movefocus, d"

              "$mod SHIFT, H, movecurrentworkspacetomonitor, l"
              "$mod SHIFT, L, movecurrentworkspacetomonitor, r"

              "$mod, S, swapactiveworkspaces, DP-1 HDMI-A-1"

              ",XF86AudioRaiseVolume, exec, pamixer -i 2"
              ",XF86AudioLowerVolume, exec, pamixer -d 2"
              ",XF86AudioMute, exec, pamixer -t"

              "$mod, 1, workspace, 1"
              "$mod, 2, workspace, 2"
              "$mod, 3, workspace, 3"
              "$mod, 4, workspace, 4"
              "$mod, 5, workspace, 5"
              "$mod, 6, workspace, 6"
              "$mod, 7, workspace, 7"
              "$mod, 8, workspace, 8"
              "$mod, 9, workspace, 9"

              "$mod SHIFT, 1, movetoworkspace, 1"
              "$mod SHIFT, 2, movetoworkspace, 2"
              "$mod SHIFT, 3, movetoworkspace, 3"
              "$mod SHIFT, 4, movetoworkspace, 4"
              "$mod SHIFT, 5, movetoworkspace, 5"
              "$mod SHIFT, 6, movetoworkspace, 6"
              "$mod SHIFT, 7, movetoworkspace, 7"
              "$mod SHIFT, 8, movetoworkspace, 8"
              "$mod SHIFT, 9, movetoworkspace, 9"
            ] ++ optionals (config.mypackages.screenshot.enable) [
              "$mod, P, exec, ${screenshot-script}/bin/screenshot"
            ] ++ optionals (config.mypackages.browser.enable) [
              "$mod, B, exec, ${config.programs.firefox.package}/bin/firefox"
            ];

            bindm = [
              # Move/Resize windows with mod + LMB/RMB
              "$mod, mouse:272, movewindow"
              "$mod, mouse:273, resizewindow"
            ];
          };
        };

        services.hyprpaper = {
          enable = true;
          settings = {
            splash = cfg.splash;
            preload = [ "${cfg.wallpaper-path}" ];
            wallpaper = (lib.forEach (monitors) (value: if (value.enable) then "${value.connector},${cfg.wallpaper-path}" else ""));
          };
        };

        home.file = {
          ".config/wlogout/style.css".text = (let
            # copied from https://gist.github.com/corpix/f761c82c9d6fdbc1b3846b37e1020e11#file-numbers-nix-L3
            pow =
              let
                pow' = base: exponent: value:
                  # FIXME: It will silently overflow on values > 2**62 :(
                  # The value will become negative or zero in this case
                  if exponent == 0
                  then 1
                  else if exponent <= 1
                  then value
                  else (pow' base (exponent - 1) (value * base));
              in base: exponent: pow' base exponent base;
            # copied from https://gist.github.com/corpix/f761c82c9d6fdbc1b3846b37e1020e11#file-numbers-nix-L38
            hex-to-dec = v:
              let
                hexToInt = {
                  "0" = 0; "1" = 1;  "2" = 2;
                  "3" = 3; "4" = 4;  "5" = 5;
                  "6" = 6; "7" = 7;  "8" = 8;
                  "9" = 9; "a" = 10; "b" = 11;
                  "c" = 12;"d" = 13; "e" = 14;
                  "f" = 15;
                };
                chars = stringToCharacters v;
                charsLen = length chars;
              in
                foldl
                  (a: v: a + v)
                  0
                  (imap0
                    (k: v: hexToInt."${v}" * (pow 16 (charsLen - k - 1)))
                    chars);
            hex-to-rgb = (hex: "${toString (hex-to-dec (builtins.substring 0 2 hex))}, ${toString (hex-to-dec (builtins.substring 2 2 hex))}, ${toString (hex-to-dec (builtins.substring 4 2 hex))}");
          in ''
            * {
              background-image: none;
              box-shadow: none;
            }

            window {
              background-color: rgba(${hex-to-rgb config.lib.stylix.colors.base00}, 0.9);
            }

            button {
              border-radius: 0;
              border-color: black;
              text-decoration-color: #${config.lib.stylix.colors.base05};
              color: #${config.lib.stylix.colors.base05};
              background-color: #${config.lib.stylix.colors.base01};
              border-style: solid;
              border-width: 1px;
              background-repeat: no-repeat;
              background-position: center;
              background-size: 25%;
            }

            button:focus, button:active, button:hover {
              background-color: #${config.lib.stylix.colors.base02};
              outline-style: none;
            }

            #lock {
                background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png"));
            }

            #logout {
                background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png"));
            }

            #suspend {
                background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"));
            }

            #hibernate {
                background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png"));
            }

            #shutdown {
                background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"));
            }

            #reboot {
                background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"));
            }
          '');
        };
      })
    ))

    (let
      cfg = config.mypackages.viewers;
    in
    (mkIf (cfg.enableAll || cfg.video.enable || cfg.image.enable) {
      home.packages = []
        ++ optionals (cfg.enableAll || cfg.video.enable) [
          pkgs.mpv
        ]
        ++ optionals (cfg.enableAll || cfg.image.enable) [
          pkgs.feh
        ];

      mypackages.impermanence = {
        directories = []
          ++ optionals (cfg.enableAll || cfg.video.enable) [
            ".config/mpv"
          ];
      };
    }))

    (let
      cfg = config.mypackages.video-editing;
    in
    (mkIf cfg.enable {
      home.packages = with pkgs; [
        davinci-resolve
      ];

      mypackages.impermanence.directories = [
        "Documents/BlackmagicDesign"
      ];
    }))

    (let
      cfg = config.mypackages.video-recording;
    in
    (mkIf (cfg.enable) {
      programs.obs-studio.enable = true;
      mypackages.impermanence.directories = [
        ".config/obs-studio"
        "Videos"
      ];
    }))

    (let
      cfg = config.mypackages.tmux;
    in
    (mkIf cfg.enable {
      programs.tmux = {
        enable = true;

        escapeTime = 50;
        terminal = "screen-256color";
        extraConfig = "set-option -ga terminal-overrides \",screen-256color:Tc\"";
      };
    }))

    (let
      cfg = config.mypackages.theme;
    in
    (mkIf cfg.enable (let
      hyprcursor-theme = "${cfg.cursorTheme.name}-hyprcursor";
    in
    {
      assertions = [
        {
          assertion = (config.mypackages.wm.enable);
          message = "Enable Window Manager to get wallpaper";
        }
      ];

      stylix.base16Scheme = cfg.theme.base16-scheme-path;

      stylix.polarity = if (cfg.prefer-dark-theme) then "dark" else "light";
      stylix.image = config.mypackages.wm.wallpaper-path;
      stylix.cursor = {
        name = cfg.cursorTheme.name;
        size = cfg.cursorTheme.size;
        package = cfg.cursorTheme.package;
      };

      gtk = {
        enable = true;
        iconTheme = {
          name = cfg.iconTheme.name;
          package = cfg.iconTheme.package;
        };
      };

      home.packages = [
        cfg.iconTheme.package
      ];

      home.file.".icons/${hyprcursor-theme}".source = mkIf cfg.cursorTheme.hyprcursor.enable "${cfg.cursorTheme.hyprcursor.package}/share/icons/${hyprcursor-theme}";
      xdg.dataFile."icons/${hyprcursor-theme}".source = mkIf cfg.cursorTheme.hyprcursor.enable "${cfg.cursorTheme.hyprcursor.package}/share/icons/${hyprcursor-theme}";
    })))

    (let
      cfg = config.mypackages.terminal;
    in
    (mkIf cfg.enable {
      programs.kitty = {
        enable = true;
      };

      home.sessionVariables = {
        TERMINAL = "kitty";
      };

      home.packages = with pkgs; [
        xdg-terminal-exec
      ];
    }))

    (let
      cfg = config.mypackages.status-bar;
    in
    (mkIf cfg.enable {
      home.packages = with pkgs; [
        pavucontrol
      ];

      programs.waybar = {
        enable = true;

        settings = {
          mainBar = {
            layer = "top";
            position = "top";
            height = 30;
            modules-left = [
              "hyprland/workspaces"
            ];
            modules-center = [ ];
            modules-right = [
              "pulseaudio"
              "temperature"
              "clock"
            ];

            temperature = {
              tooltip = false;
            };

            pulseaudio = {
              on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
            };

            clock = {
              format = "{:%H:%M}  ";
              format-alt = "{:%A, %B %d, %Y (%R)}  ";
              tooltip-format = "<tt><small>{calendar}</small></tt>";
              calendar = {
                mode = "year";
                mode-mon-col = 3;
                weeks-pos = "right";
                on-scroll = 1;
                format = {
                  months = "<span color='#${config.lib.stylix.colors.base0A}'><b>{}</b></span>";
                  days = "<span color='#${config.lib.stylix.colors.base0E}'><b>{}</b></span>";
                  weeks = "<span color='#${config.lib.stylix.colors.base0D}'><b>W{}</b></span>";
                  weekdays = "<span color='#${config.lib.stylix.colors.base09}'><b>{}</b></span>";
                  today = "<span color='#${config.lib.stylix.colors.base08}'><b><u>{}</u></b></span>";
                  };
                };
              actions =  {
                on-click-right = "mode";
                on-click-forward = "tz_up";
                on-click-backward = "tz_down";
                on-scroll-up = "shift_up";
                on-scroll-down = "shift_down";
              };
            };
          };
        };

        style = ''
          * {
            border: none;
            border-radius: 0;
            font-family: FiraCode;
            font-size: 13px;
            min-height: 0;
          }

          window#waybar {
            border-bottom: 3px solid #${config.lib.stylix.colors.base01};
          }

          #workspaces button {
            padding: 0 5px;
            background: transparent;
            color: #${config.lib.stylix.colors.base05};
            border-bottom: 3px solid transparent;
          }

          #mode, #clock, #temperature, #pulseaudio {
            margin-left: 5px;
            padding: 0 10px;
          }

          #clock {
            background-color: #${config.lib.stylix.colors.base0E};
          }

          #temperature {
            background-color: #${config.lib.stylix.colors.base09};
          }

          #pulseaudio {
            background-color: #${config.lib.stylix.colors.base0B};
          }

          #clock,
          #temperature,
          #pulseaudio {
            color: #${config.lib.stylix.colors.base04};
          }
        '';
      };
    }))

    (mkIf (osConfig.mypackages.shell.enable) {
      programs.zsh.enable = true;
    })

    (let
      cfg = config.mypackages.screenshot;
    in
    (mkIf cfg.enable {
      home.packages = with pkgs; [
        grim
        slurp
        satty
      ];

      mypackages.impermanence = {
        directories = [
          ".config/satty"
          cfg.savePicturesPath
        ];
      };
    }))

    (let
      cfg = config.mypackages.office;
    in
    (mkIf (cfg.enable) {
      home.packages = with pkgs; [
        libreoffice-fresh
      ];

      mypackages.impermanence.directories = [
        ".config/libreoffice"
      ];
    }))

    (let
      cfg = config.mypackages.notifications;
    in
    (mkIf cfg.enable {
      services.dunst.enable = true;

      mypackages.impermanence.directories = [
        ".config/dunst"
      ];
    }))


    (let
      cfg = config.mypackages.notes;
    in
    (mkIf cfg.enable {
      home.packages = with pkgs; [
        obsidian
      ];

      mypackages.impermanence = {
        directories = [
          ".config/obsidian"
          "Notes"
        ];
      };

      nixpkgs.config.allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "obsidian"
        ];
    }))

    (mkIf osConfig.mypackages.networkmanager.enable {
      xdg.desktopEntries = {
        NetworkManager = {
          name = "Network Manager Settings";
          genericName = "Network";
          exec = "nmtui";
          icon = "tdenetworkmanager";
          terminal = true;
          categories = [ "Network" ];
        };
      };
    })

    (mkIf osConfig.mypackages.network-tools.enable {
      mypackages.impermanence.directories = [
        ".config/filezilla"
      ];
    })

    (let
      cfg = config.mypackages.ls;
    in
    (mkIf cfg.enable {
      programs.eza = {
        enable = true;
        enableZshIntegration = mkIf (osConfig.mypackages.shell.enable) true;
        enableBashIntegration = mkIf (!osConfig.mypackages.shell.enable) true;
      };

      programs.zsh.shellAliases = mkIf (osConfig.mypackages.shell.enable) {
        ls = "eza";
      };

      programs.bash.shellAliases = mkIf (!osConfig.mypackages.shell.enable) {
        ls = "eza";
      };
    }))

    (let
      cfg = config.mypackages.ldtk;
    in
    (mkIf cfg.enable {
      home.packages = with pkgs; [
        ldtk
      ];

      mypackages.impermanence.directories = [
        ".config/LDtk"
      ];
    }))

    (let
      cfg = config.mypackages.launcher;
    in
    (mkIf cfg.enable (let
      # Copied from https://github.com/danth/stylix/blob/ca3247ed8cfbf369f3fe1b7a421579812a95c101/modules/fuzzel/hm.nix#L25
      font = "${config.stylix.fonts.sansSerif.name}:size=${toString config.stylix.fonts.sizes.popups}:weight=bold";
    in {
      programs.fuzzel = {
        enable = true;
        settings = {
          main = {
            terminal = "${pkgs.kitty}/bin/kitty";
            dpi-aware = "no";
            width = 25;
            line-height = 25;
            prompt = "❯ ";
            icon-theme = "${config.mypackages.theme.iconTheme.name}";
            font = mkForce font;
          };

          border = {
            radius = 5;
          };
        };
      };

      home.packages = with pkgs; [
        bemoji
      ];

      mypackages.impermanence.directories = [
        ".config/networkmanager-dmenu"
      ];

      home.file = {
        ".config/networkmanager-dmenu/config.ini".text = ''
        [dmenu]
        dmenu_command = ${pkgs.fuzzel}/bin/fuzzel --dmenu
        '';
      };
    })))

    (let
      osCfg = osConfig.mypackages.impermanence;
      cfg = config.mypackages.impermanence;
    in
    (mkIf (cfg.enable && osCfg.enable) {
      home.persistence."${cfg.persistent-path}" = {
        directories = cfg.directories;
        files = cfg.files;
        allowOther = true;
      };
    }))

    (let
      cfg = config.mypackages.image-editors;
    in
    (mkIf cfg.enable {
      home.packages = with pkgs; [
        gimp
        inkscape
      ];

      mypackages.impermanence = {
        directories = [
          ".config/GIMP"
          ".config/inkscape"
          "Pictures"
        ];
      };
    }))

    (let
      cfg = config.mypackages.git;
    in
    (mkIf cfg.enable {
      programs.git = {
        enable = true;

        userName = cfg.userName;
        userEmail = cfg.userEmail;

        extraConfig = {
          init.defaultBranch = "main";
        };
      };
    }))

    (let
      cfg = config.mypackages.find;
    in
    (mkIf cfg.enable {
      programs.fd.enable = true;
    }))

    (let
      cfg = config.mypackages.file-explorer;
    in
    (mkIf cfg.enable {
      home.packages = with pkgs; [
        file-roller
      ];

      mypackages.impermanence.directories = [
        ".config/gtk-3.0/bookmarks"
        ".config/Thunar"
        ".config/xfce4"
      ];
    }))

    (let
      cfg = config.mypackages.communication;
    in
    (mkIf cfg.enable {
      home.packages = with pkgs; [
        webcord
      ];

      mypackages.impermanence = {
        directories = [
          ".config/WebCord"
        ];
      };
    }))

    (let
      cfg = config.mypackages.cd;
    in
    (mkIf cfg.enable {
      programs.zoxide = {
        enable = true;
        enableZshIntegration = mkIf (osConfig.mypackages.shell.enable) true;
        enableBashIntegration = mkIf (!osConfig.mypackages.shell.enable) true;
      };

      programs.zsh.shellAliases = mkIf (osConfig.mypackages.shell.enable) {
        cd = "z";
      };

      programs.bash.shellAliases = mkIf (!osConfig.mypackages.shell.enable) {
        cd = "z";
      };

      mypackages.impermanence.directories = [
        ".local/share/zoxide"
      ];
    }))

    (let
      cfg = config.mypackages.casparcg-client;
    in
    (mkIf cfg.enable {
      home.packages = with pkgs; [
        casparcg-client
      ];

      mypackages.impermanence.directories = [
        ".CasparCG"
      ];
    }))

    (let
      cfg = config.mypackages.calendar;
    in
    (mkIf cfg.enable {
      home.packages = with pkgs; [
        merkuro
      ];

      mypackages.impermanence.directories = [
        ".config/KDE"
      ];
    }))

    (let
      cfg = config.mypackages.browser;
    in
    (mkIf cfg.enable {
      programs.firefox = {
        enable = true;
        profiles.default = {
          settings = {
            "signon.rememberSignons" = false;
          };
          search = {
            engines = {
              "Nix Packages" = {
                urls = [{
                  template = "https://search.nixos.org/packages";
                  params = [
                    { name = "type"; value = "packages"; }
                    { name = "channel"; value = "unstable"; }
                    { name = "query"; value = "{searchTerms}"; }
                  ];
                }];

                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@np" ];
              };
              "NixOS Options" = {
                urls = [{
                  template = "https://search.nixos.org/options";
                  params = [
                    { name = "type"; value = "options"; }
                    { name = "channel"; value = "unstable"; }
                    { name = "query"; value = "{searchTerms}"; }
                  ];
                }];

                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@no" ];
              };
              "NixOS Home Manager Options" = {
                urls = [{
                  template = "https://home-manager-options.extranix.com";
                  params = [
                    { name = "release"; value = "master"; }
                    { name = "query"; value = "{searchTerms}"; }
                  ];
                }];

                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@nh" ];
              };
              "Noogle" = {
                urls = [{
                  template = "https://noogle.dev/q";
                  params = [
                    { name = "term"; value = "{searchTerms}"; }
                  ];
                }];

                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@ne" ];
              };
            };
            force = true;
          };
          # TODO: get somehow system architecture
          extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
            proton-pass
          ];
        };
      };

      mypackages.impermanence = {
        directories = [
          ".mozilla"
          "Downloads"
        ];
      };

      home.activation.symlinks = hm.dag.entryAfter ["writeBoundary"] ''
        run ln -sfn $HOME/Downloads $HOME/Pobrane
      '';
    }))

    (let
      cfg = config.mypackages.bottles;
    in
    (mkIf (osConfig.mypackages.bottles.enable && cfg.enable) {
      mypackages.impermanence = {
        directories = [
          {
            directory = ".local/share/bottles";
            method = "symlink";
          }
        ];
      };
    }))

  ];
}
