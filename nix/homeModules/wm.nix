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
    ];

    wayland.windowManager.hyprland = {
      enable = true;

      settings = {
        exec-once = [
          "hyprpaper"
          "waybar"
          "ags"
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
          # TODO: fix
          # Hyprcursor doesn't work for now on NixOS :(
          # Related issue: https://github.com/hyprwm/hyprcursor/issues/19
          # "HYPRCURSOR_THEME,${config.mypackages.theme.cursorTheme.name}"
          # "HYPRCURSOR_SIZE,${builtins.toString config.mypackages.theme.cursorTheme.size}"
          "XCURSOR_THEME,${config.mypackages.theme.cursorTheme.name}"
          "XCURSOR_SIZE,${builtins.toString config.mypackages.theme.cursorTheme.size}"
        ] ++ lib.optionals (osConfig.mypackages.nvidia.enable && !osConfig.mypackages.nvidia.open.enable) [
          "LIBVA_DRIVER_NAME,nvidia"
        ] ++ lib.optionals config.mypackages.browser.enable [
          "MOZ_ENABLE_WAYLAND,1"
        ] ++ lib.optionals (osConfig.mypackages.nvidia.enable && osConfig.mypackages.nvidia.open.enable) [
          "WLR_NO_HARDWARE_CURSORS,1"
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

    home.file = {
      ".config/hypr/hyprpaper.conf".text =
        let
          monitorsConfig = (lib.concatStrings (lib.forEach (monitors) (value:
            if (value.enable) then
              "wallpaper = ${value.connector},${cfg.wallpaper-path}\n"
            else
              ""
          )));
        in
        ''
          preload = ${cfg.wallpaper-path}
          ${monitorsConfig}
          splash = ${trivial.boolToString cfg.splash}
        '';

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
