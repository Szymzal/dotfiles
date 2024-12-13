{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}:
with lib; let
  cfg = config.mypackages.wm;
in {
  options = {
    mypackages.wm = {
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
  };

  config =
    mkIf cfg.enable
    (let
      power-menu-script = pkgs.writeShellScriptBin "power-menu" ''
        killall wlogout || ${pkgs.wlogout}/bin/wlogout
      '';
      screenshot-script = pkgs.writeShellScriptBin "screenshot" ''
        ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -o -r -c '#ff0000ff')" - | ${pkgs.satty}/bin/satty --filename - --fullscreen --output-filename ~/${config.mypackages.screenshot.savePicturesPath}/$(date '+%Y%m%d-%H:%M:%S').png
      '';
      monitors = osConfig.mypackages.monitors.config;
    in {
      mypackages = {
        terminal.enable = mkDefault true;
        status-bar.enable = mkDefault true;
        launcher.enable = mkDefault true;
        notifications.enable = mkDefault true;
      };

      home.packages = with pkgs; [
        killall
        pamixer
        wlogout
        wlr-randr
        way-displays
      ];

      wayland.windowManager.river = {
        enable = true;

        settings = {
          declare-mode = [
            "passthrough"
            "launcher"
          ];
          map = let
            mediaButtons = {
              "None XF86AudioRaiseVolume" = "spawn 'pamixer -i 2'";
              "None XF86AudioLowerVolume" = "spawn 'pamixer -d 2'";
              "None XF86AudioMute" = "spawn 'pamixer -t'";
              # TODO: Why it is not working?
              "None XF86AudioMicMute" = "spawn 'pamixer --default-source -t'";
            };
          in {
            launcher = {
              "None B" = "spawn ${lib.getExe config.programs.chromium.package}";
              "None T" = "spawn thunar";
              "None Escape" = "enter-mode normal";
            };
            passthrough = {
              "Super F11" = "enter-mode normal";
            };
            locked = mediaButtons;
            normal =
              {
                "Super Return" = "spawn foot";
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
              }
              // (
                let
                  loop = i: to: let
                    tags = "$((1 << (${builtins.toString i} - 1)))";
                  in (
                    {
                      "Super ${builtins.toString i}" = "set-focused-tags ${tags}";
                      "Super+Shift ${builtins.toString i}" = "set-view-tags ${tags}";
                      "Super+Control ${builtins.toString i}" = "toggle-focused-tags ${tags}";
                      "Super+Shift+Control ${builtins.toString i}" = "toggle-view-tags ${tags}";
                    }
                    // lib.optionalAttrs (i < to) (loop (i + 1) to)
                  );
                in
                  loop 1 9
              )
              // (let
                allTags = "$(((1 << 32) - 1))";
              in {
                "Super 0" = "set-focused-tags ${allTags}";
                "Super+Shift 0" = "set-view-tags ${allTags}";
              })
              // mediaButtons;
          };
          map-pointer = {
            normal = {
              "Super BTN_LEFT" = "move-view";
              "Super BTN_RIGHT" = "resize-view";
            };
          };
          xcursor-theme = mkForce "${config.mypackages.theme.cursorTheme.name} ${builtins.toString config.mypackages.theme.cursorTheme.size}";
          rule-add = {
            "" = "ssd";
            "-app-id" = {
              "'bar'" = "csd";
              "float" = "float";
              "'org.gnome.FileRoller'" = "float";
              "'org.pulseaudio.pavucontrol'" = "float";
              "'blueman-manager'" = "float";
              "'firefox'" = {
                "-title" = {
                  "'Picture-in-Picture'" = "float";
                };
              };
            };
            "-title" = {
              "'MainPicker'" = "float";
            };
          };
          border-color-focused = "0x${config.lib.stylix.colors.base0D}";
          border-color-unfocused = "0x${config.lib.stylix.colors.base03}";
          set-repeat = "50 300";
          default-layout = "rivertile";
          focus-follows-cursor = "normal";
          set-cursor-warp = "on-focus-change";
          hide-cursor.when-typing = "enabled";
          keyboard-layout = "pl";
          spawn = [
            "way-displays"
            "waybar"
            "rivertile"
          ];
        };

        extraSessionVariables =
          {
            XDG_SESSION_TYPE = "wayland";
            XDG_CURRENT_DESKTOP = "river";
            NIXOS_OZONE_WL = "1";
          }
          // lib.optionalAttrs (osConfig.mypackages.nvidia.enable && !osConfig.mypackages.nvidia.open.enable) {
            LIBVA_DRIVER_NAME = "nvidia";
          }
          // lib.optionalAttrs config.mypackages.browser.enable {
            MOZ_ENABLE_WAYLAND = "0";
          }
          // lib.optionalAttrs (osConfig.mypackages.nvidia.enable && osConfig.mypackages.nvidia.open.enable) {
            WLR_NO_HARDWARE_CURSORS = "1";
          };

        systemd.enable = true;

        xwayland.enable = true;
      };

      services.hyprpaper = {
        enable = true;
        settings = {
          splash = cfg.splash;
          preload = ["${cfg.wallpaper-path}"];
          wallpaper = lib.forEach monitors (value:
            if (value.enable)
            then "${value.connector},${cfg.wallpaper-path}"
            else "");
        };
      };

      home.file = {
        ".config/wlogout/style.css".text = let
          # copied from https://gist.github.com/corpix/f761c82c9d6fdbc1b3846b37e1020e11#file-numbers-nix-L3
          pow = let
            pow' = base: exponent: value:
              if exponent == 0
              then 1
              else if exponent <= 1
              then value
              else (pow' base (exponent - 1) (value * base));
          in
            base: exponent: pow' base exponent base;
          # copied from https://gist.github.com/corpix/f761c82c9d6fdbc1b3846b37e1020e11#file-numbers-nix-L38
          hex-to-dec = v: let
            hexToInt = {
              "0" = 0;
              "1" = 1;
              "2" = 2;
              "3" = 3;
              "4" = 4;
              "5" = 5;
              "6" = 6;
              "7" = 7;
              "8" = 8;
              "9" = 9;
              "a" = 10;
              "b" = 11;
              "c" = 12;
              "d" = 13;
              "e" = 14;
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
          hex-to-rgb = hex: "${toString (hex-to-dec (builtins.substring 0 2 hex))}, ${toString (hex-to-dec (builtins.substring 2 2 hex))}, ${toString (hex-to-dec (builtins.substring 4 2 hex))}";
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
        '';
      };
    });
}
