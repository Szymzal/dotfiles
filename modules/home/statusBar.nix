{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.mypackages.status-bar;
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs) system;
  };
in {
  options = {
    mypackages.status-bar = {
      enable = mkEnableOption "Enable status bar";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      pavucontrol
    ];

    programs.hyprpanel = {
      enable = true;
      package = pkgs-unstable.hyprpanel;
      settings = {
        theme = {
          font = {
            size = "0.8rem";
            weight = 600;
          };
          bar.floating = true;
        };
        bar = {
          customModules = {
            storage.paths = [
              "/"
            ];
            microphone.label = true;
            netstat = {
              label = true;
              dynamicIcon = false;
            };
            kbLayout.label = false;
            updates.label = false;
            weather.label = false;
            hyprsunset.label = false;
          };
          clock.format = "%a %d %b - %k:%M:%S";

          layouts = {
            "*" = {
              left = [
                "dashboard"
                "workspaces"
                "windowtitle"
              ];
              middle = [
                "media"
              ];
              right = [
                "volume"
                "systray"
                "clock"
                "notifications"
              ];
            };
          };
        };
        menus = {
          clock.weather = {
            location = "98-235";
            unit = "metric";
          };

          volume.raiseMaximumVolume = true;
          dashboard = {
            shortcuts.enabled = false;
            directories.enabled = false;
            powermenu.logout = "${lib.getExe pkgs.uwsm} stop";
          };
        };
      };
    };

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
          modules-center = [];
          modules-right = [
            "pulseaudio"
            "temperature"
            "clock"
          ];

          "hyprland/workspaces" = {
            format = "{icon}";
            format-icons = {
              urgent = "";
              active = "";
              visible = "";
              default = "";
              empty = "";
            };
            all-outputs = false;
          };

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
            actions = {
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
  };
}
