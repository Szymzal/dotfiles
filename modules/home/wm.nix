{
  pkgs,
  lib,
  config,
  osConfig,
  inputs,
  ...
}:
with lib; let
  myLib = osConfig.lib.myLib;
  cfg = config.mypackages.wm;
in {
  imports = [
    inputs.mango.hmModules.mango
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
      uwsm = mkOption {
        default = true;
        example = false;
        description = "Enable UWSM intergration";
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
      monitors = osConfig.mypackages.monitors.config;
    in {
      mypackages = {
        terminal.enable = mkDefault true;
        status-bar.enable = mkDefault true;
        launcher.enable = mkDefault true;
        notifications.enable = mkDefault true;
        screenshot.enable = mkDefault true;
      };

      home.file.".config/gromit-mpx.ini".text = lib.generators.toINI {} {
        General.ShowIntroOnStartup = false;
        Drawing.Opacity = 0.0;
      };

      home.packages = with pkgs; [
        killall
        pamixer
        wlr-randr
        way-displays
        cliphist
        config.mypackages.theme.cursorTheme.xcursor.package
        config.mypackages.theme.cursorTheme.hyprcursor.package
        pkgs-unstable.wayscriber
      ];

      wayland.windowManager = {
        mango = {
          enable = true;
          settings = ''
            exec-once=waybar

            env=GTK_THEME,Adwaita:dark
            env=XCURSOR_SIZE,16

            env=XDG_CURRENT_DESKTOP,wlroots
            env=NIXOS_OZONE_WL,1
            env=LIBVA_DRIVER_NAME,nvidia
            env=__GLX_VENDOR_LIBRARY_NAME,nvidia
            env=NVD_BACKEND,direct

            monitorrule=DP-1,0.55,1,tile,0,1,0,0,1920,1080,144
            monitorrule=HDMI-A-1,0.55,1,tile,0,1,1920,0,1920,1080,144

            allow_tearing=1
            xkb_rules_layout=pl
            adaptive_sync=1
            allow_lock_transparent=1
            cursor_size=16
            cursor_theme=Bibata-Modern-Classic
            enable_hotarea=0

            # Cycle through layouts
            bind=SUPER,n,switch_layout

            # Set specific layout
            bind=SUPER,t,setlayout,tile
            bind=SUPER,s,setlayout,scroller

            bind=SUPER,Return,spawn,${optionalString cfg.uwsm "uwsm app -- "}foot
            bind=SUPER,q,killclient,
            bind=SUPER+SHIFT,q,quit
            bind=SUPER,o,spawn,${optionalString cfg.uwsm "uwsm app -- "}${getExe power-menu-script}

            bind=SUPER,d,spawn_shell,killall fuzzel || fuzzel ${optionalString cfg.uwsm ''--launch-prefix="uwsm app -- " --log-no-syslog --log-level=warning''}

            bind=SUPER,space,togglefloating
            bind=SUPER,f,togglefullscreen

            bind=SUPER,h,focusdir,l
            bind=SUPER,l,focusdir,r
            bind=SUPER,k,focusdir,u
            bind=SUPER,j,focusdir,d

            bind=SUPER+SHIFT,h,tagmon,l
            bind=SUPER+SHIFT,l,tagmon,r
            bind=SUPER+SHIFT,j,tagmon,u
            bind=SUPER+SHIFT,k,tagmon,d

            bind=NONE,XF86AudioRaiseVolume,spawn,pamixer -i 2
            bind=NONE,XF86AudioLowerVolume,spawn,pamixer -d 2
            bind=NONE,XF86AudioMute,spawn,pamixer -t

            bind=SUPER,p,spawn,${optionalString cfg.uwsm "uwsm app -- "}${getExe pkgs.pkgs-unstable.grimblast} --notify --openfile --freeze copysave area

            ${
              # workspaces
              # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
              builtins.concatStringsSep "" (builtins.genList (
                  i: let
                    ws = i + 1;
                  in ''
                    bind=SUPER,${toString ws},view,${toString ws}
                    bind=SUPER+SHIFT,${toString ws},tag,${toString ws}
                  ''
                )
                9)
            }

            # Move window with Super + Left Click
            mousebind=SUPER,btn_left,moveresize,curmove

            # Resize window with Super + Right Click
            mousebind=SUPER,btn_right,moveresize,curresize

            bind=SUPER,z,setkeymode,apps
            keymode=apps
            bind=NONE,b,spawn,${optionalString cfg.uwsm "uwsm app -- "}${getExe inputs.zen-browser.packages."${pkgs.system}".default}
            bind=NONE,b,setkeymode,default
            ${optionalString config.mypackages.file-explorer.enable "bind=NONE,f,spawn,${optionalString cfg.uwsm "uwsm app -- "}thunar"}
            ${optionalString config.mypackages.file-explorer.enable "bind=NONE,f,setkeymode,default"}
            bind=NONE,t,spawn,${optionalString cfg.uwsm "uwsm app -- "}${getExe config.programs.foot.package} ${getExe pkgs.btop}
            bind=NONE,t,setkeymode,default
            bind=NONE,Escape,setkeymode,default
          '';
          autostart_sh = ''
            uwsm finalize

            # Keep clipboard content after app closes
            wl-clip-persist --clipboard regular --reconnect-tries 0 &

            # Watch clipboard and store history
            wl-paste --type text --watch cliphist store &
          '';
        };
        hyprland = {
          enable = true;
          package = null;
          portalPackage = null;
          plugins = [
            inputs.hyprsplit.packages.${pkgs.system}.hyprsplit
          ];
          systemd.enable = false;

          settings = {
            exec-once = [
              # "${lib.getExe pkgs.way-displays}"
              # "waybar"
              "${lib.getExe pkgs.pkgs-unstable.wayscriber} -d"
            ];

            input = {
              kb_layout = "pl";
            };

            debug = {
              disable_logs = false;
            };

            cursor = {
              no_hardware_cursors = true;
            };

            misc = {
              disable_hyprland_logo = true;
              layers_hog_keyboard_focus = true;
              mouse_move_focuses_monitor = true;
              enable_anr_dialog = false;
            };

            ecosystem = {
              no_update_news = true;
            };

            animations = {
              enabled = false;
            };

            plugin = {
              hyprsplit = {
                count = 9;
              };
            };

            general = {
              gaps_in = 2;
              gaps_out = 5;
            };

            env = [
              "XDG_SESSION_TYPE,wayland"
              "NIXOS_OZONE_WL,1"
              "LIBVA_DRIVER_NAME,nvidia"
              "__GLX_VENDOR_LIBRARY_NAME,nvidia"
              "NVD_BACKEND,direct"
              "XCURSOR_THEME,${config.mypackages.theme.cursorTheme.xcursor.name}"
              "XCURSOR_SIZE,${toString config.mypackages.theme.cursorTheme.size}"
              "HYPRCURSOR_THEME,${config.mypackages.theme.cursorTheme.hyprcursor.name}"
              "HYPRCURSOR_SIZE,${toString config.mypackages.theme.cursorTheme.size}"
            ];

            "$terminal" = "foot";
            "$mod" = "SUPER";

            monitor = myLib.hyprlandMonitorsConfig;

            bind =
              [
                "$mod, Return, exec, $terminal"
                "$mod, Q, killactive"
                "$mod SHIFT, Q, exec, hyprctl kill"
                ("$mod, O, exec, " + optionalString cfg.uwsm "uwsm app -- " + "${getExe power-menu-script}")

                (''$mod, D, exec, killall fuzzel || fuzzel '' + optionalString cfg.uwsm ''--launch-prefix="uwsm app -- " --log-no-syslog --log-level=warning'')

                "$mod, M, exec, pkill -SIGUSR1 wayscriber"

                "$mod, Space, togglefloating"
                "$mod, F, fullscreen"

                "$mod, H, movefocus, l"
                "$mod, L, movefocus, r"
                "$mod, K, movefocus, u"
                "$mod, J, movefocus, d"

                "$mod SHIFT, H, movewindow, mon:+1"
                "$mod SHIFT, L, movewindow, mon:-1"

                "$mod SHIFT, G, split:grabroguewindows"
                "$mod, S, split:swapactiveworkspaces, current +1"

                ",XF86AudioRaiseVolume, exec, pamixer -i 2"
                ",XF86AudioLowerVolume, exec, pamixer -d 2"
                ",XF86AudioMute, exec, pamixer -t"

                ("$mod, P, exec, " + optionalString cfg.uwsm "uwsm app -- " + "${getExe pkgs.pkgs-unstable.grimblast} --notify --freeze edit area")

                "$mod, Z, submap, apps"
              ]
              ++ (
                # workspaces
                # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
                builtins.concatLists (builtins.genList (
                    i: let
                      ws = i + 1;
                    in [
                      "$mod, code:1${toString i}, split:workspace, ${toString ws}"
                      "$mod SHIFT, code:1${toString i}, split:movetoworkspace, ${toString ws}"
                    ]
                  )
                  9)
              );

            bindm = [
              # Move/Resize windows with mod + LMB/RMB
              "$mod, mouse:272, movewindow"
              "$mod, mouse:273, resizewindow"
            ];
          };
          # TODO: Why there is no package for thunar?
          extraConfig = ''
            submap = apps

            bind = , B, exec, ${optionalString cfg.uwsm "uwsm app -- "}${getExe inputs.zen-browser.packages."${pkgs.system}".default}
            bind = , B, submap, reset
            ${optionalString config.mypackages.file-explorer.enable "bind = , F, exec, ${optionalString cfg.uwsm "uwsm app -- "}thunar"}
            ${optionalString config.mypackages.file-explorer.enable "bind = , F, submap, reset"}
            bind = , T, exec, ${optionalString cfg.uwsm "uwsm app -- "}${getExe config.programs.foot.package} ${getExe pkgs.btop}
            bind = , T, submap, reset

            bind = , escape, submap, reset

            submap = reset
          '';
        };
      };

      xdg.configFile."uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

      services.hyprpaper = {
        enable = true;
        settings = {
          inherit (cfg) splash;
          preload = ["${cfg.wallpaper-path}"];
          wallpaper = filter (x: x != null) (lib.forEach monitors (value:
            if value.enable
            then "${value.connector},${cfg.wallpaper-path}"
            else null));
        };
      };

      services.hypridle = {
        enable = true;
        settings = {
          listener = mkForce [
            {
              timeout = 900;
              on-timeout = "hyprlock";
            }
          ];
        };
      };

      programs = {
        hyprlock = {
          enable = true;
          settings = {
            general = {
              no_fade_out = true;
            };
          };
        };
        wlogout = {
          enable = true;
          layout = [
            {
              label = "shutdown";
              action = "systemctl poweroff";
              text = "Shutdown";
              keybind = "s";
            }
            {
              label = "reboot";
              action = "systemctl reboot";
              text = "Reboot";
              keybind = "r";
            }
            {
              label = "lock";
              action = "loginctl lock-session";
              text = "Lock";
              keybind = "l";
            }
            {
              label = "logout";
              action = "${lib.getExe pkgs.uwsm} stop";
              text = "Logout";
              keybind = "e";
            }
          ];
          style = let
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
      };

      mypackages.impermanence.directories = [
        ".config/wayscriber"
      ];
    });
}
