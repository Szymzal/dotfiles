{ inputs, pkgs, lib, config, osConfig, ... }:
with lib;
let
  myLib = osConfig.lib.myLib;
  cfg = config.mypackages.wm;
in
{
  imports = [
    inputs.hyprland.homeManagerModules.default
  ];

  options = {
    mypackages.wm = {
      enable = mkEnableOption "Enable window manager";
      preset = mkOption {
        default = "hyprland";
        example = "river";
        description = "What WM to choose";
        type = types.enum [ "river" "hyprland" ];
      };
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
  };

  config = mkIf cfg.enable
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
      wlr-randr
    ] ++ optionals (cfg.preset == "hyprland") [
      xdg-desktop-portal-hyprland
    ] ++ optionals (cfg.preset == "river") [
      xdg-desktop-portal-wlr
    ];

    wayland.windowManager.hyprland = mkIf (cfg.preset == "hyprland") {
      enable = true;

      settings = {
        exec-once = [
          "hyprpaper"
          "waybar"
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
          "MOZ_ENABLE_WAYLAND,0"
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

    wayland.windowManager.river = mkIf (cfg.preset == "river") {
      enable = true;

      settings = {
        declare-mode = [
          "passthrough"
          "launcher"
        ];
        map = (let
          mediaButtons = {
            "None XF86AudioRaiseVolume" = "spawn 'pamixer -i 2'";
            "None XF86AudioLowerVolume" = "spawn 'pamixer -d 2'";
            "None XF86AudioMute" = "spawn 'pamixer -t'";
          };
        in {
          launcher = {
            "None B" = "spawn ${config.programs.firefox.package}/bin/firefox";
            "None T" = "spawn thunar";
            "None Escape" = "enter-mode normal";
          };
          passthrough = {
            "Super F11" = "enter-mode normal";
          };
          locked = mediaButtons;
          normal = {
            "Super Return" = "spawn kitty";
            "Super Q" = "close";

            "Super O" = "spawn ${power-menu-script}/bin/power-menu";
            "Super D" = "spawn 'killall fuzzel || fuzzel'";
            "Super P" = "spawn ${screenshot-script}/bin/screenshot";

            "Super Space" = "toggle-float";

            "Super J" = "focus-view next";
            "Super K" = "focus-view previous";

            "Super+Shift J" = "swap next";
            "Super+Shift K" = "swap previous";

            "Super Period" = "focus-output next";
            "Super Comma" = "focus-output previous";

            "Super+Shift Period" = "send-to-output next";
            "Super+Shift Comma" = "send-to-output previous";

            "Super T" = "zoom";

            "Super H" = "send-layout-cmd rivertile 'main-ratio -0.05'";
            "Super L" = "send-layout-cmd rivertile 'main-ratio +0.05'";

            "Super+Shift H" = "send-layout-cmd rivertile 'main-count +1'";
            "Super+Shift L" = "send-layout-cmd rivertile 'main-count -1'";

            "Super+Alt H" = "move left 100";
            "Super+Alt J" = "move down 100";
            "Super+Alt K" = "move up 100";
            "Super+Alt L" = "move right 100";

            "Super+Alt+Control H" = "snap left";
            "Super+Alt+Control J" = "snap down";
            "Super+Alt+Control K" = "snap up";
            "Super+Alt+Control L" = "snap right";

            "Super+Alt+Shift H" = "resize horizontal -100";
            "Super+Alt+Shift J" = "resize vertical 100";
            "Super+Alt+Shift K" = "resize vertical -100";
            "Super+Alt+Shift L" = "resize horizontal 100";

            "Super F" = "toggle-fullscreen";

            "Super Up" = "send-layout-cmd rivertile 'main-location top'";
            "Super Right" = "send-layout-cmd rivertile 'main-location right'";
            "Super Down" = "send-layout-cmd rivertile 'main-location bottom'";
            "Super Left" = "send-layout-cmd rivertile 'main-location left'";

            "Super F11" = "enter-mode passthrough";
            "Super Z" = "enter-mode launcher";
          } // (let
            loop = (i: to: let
              tags = "$((1 << (${builtins.toString i} - 1)))";
            in (
              {
                "Super ${builtins.toString i}" = "set-focused-tags ${tags}";
                "Super+Shift ${builtins.toString i}" = "set-view-tags ${tags}";
                "Super+Control ${builtins.toString i}" = "toggle-focused-tags ${tags}";
                "Super+Shift+Control ${builtins.toString i}" = "toggle-view-tags ${tags}";
              } // lib.optionalAttrs (i < to) (loop (i + 1) to)
            ));
          in
            loop 1 9
          ) // (let
            allTags = "$(((1 << 32) - 1))";
          in (
            {
              "Super 0" = "set-focused-tags ${allTags}";
              "Super+Shift 0" = "set-view-tags ${allTags}";
            }
          )) // mediaButtons;
        });
        map-pointer = {
          normal = {
            "Super BTN_LEFT" = "move-view";
            "Super BTN_RIGHT" = "resize-view";
          };
        };
        xcursor-theme = "${config.mypackages.theme.cursorTheme.name} ${builtins.toString config.mypackages.theme.cursorTheme.size}";
        rule-add."-app-id" = {
          "'bar'" = "csd";
          "firefox" = "ssd";
          "float" = "float";
          "'org.pulseaudio.pavucontrol'" = "float";
          "'blueman-manager'" = "float";
          "'firefox'" = {
            "-title" = {
              "'Picture-in-Picture'" = "float";
            };
          };
        };
        border-color-focused = "0x${config.lib.stylix.colors.base0D}";
        border-color-unfocused = "0x${config.lib.stylix.colors.base03}";
        set-repeat = "50 300";
        default-layout = "rivertile";
        focus-follows-cursor = "normal";
        keyboard-layout = "pl";
        spawn = [
          "hyprpaper"
          "waybar"
          "rivertile"
        ];
      };

      extraSessionVariables = {
        XDG_SESSION_TYPE = "wayland";
        NIXOS_OZONE_WL = "1";
      } // lib.optionalAttrs (osConfig.mypackages.nvidia.enable && !osConfig.mypackages.nvidia.open.enable) {
        LIBVA_DRIVER_NAME = "nvidia";
      } // lib.optionalAttrs config.mypackages.browser.enable {
        MOZ_ENABLE_WAYLAND = "0";
      } // lib.optionalAttrs (osConfig.mypackages.nvidia.enable && osConfig.mypackages.nvidia.open.enable) {
        WLR_NO_HARDWARE_CURSORS = "1";
      };

      systemd.enable = true;

      xwayland.enable = true;
    };

    services.kanshi = mkIf (cfg.preset == "river") {
      enable = true;
      settings = [
        {
          profile.name = "default";
          profile.outputs = (lib.forEach (monitors) (value:
          # TODO: Exclude Unknown-1 monitor
          (mkIf value.enable {
            status = if (value.enable) then "enable" else "disable";
            adaptiveSync = false;
            criteria = value.connector;
            position = "${builtins.toString value.position.x},${builtins.toString value.position.y}";
            scale = value.mode.scale;
            transform = "normal";
            mode = "${builtins.toString value.mode.width}x${builtins.toString value.mode.height}@${builtins.toString value.mode.rate}Hz";
          })
        ));
        }
      ];
      systemdTarget = "river-session.target";
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
  });
}
