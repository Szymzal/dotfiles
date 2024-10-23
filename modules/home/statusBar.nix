{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mypackages.status-bar;
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

    programs.waybar = {
      enable = true;

      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;
          modules-left =
            []
            ++ optionals (config.mypackages.wm.preset == "hyprland") [
              "hyprland/workspaces"
            ]
            ++ optionals (config.mypackages.wm.preset == "river") [
              "river/tags"
            ];
          modules-center = [];
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
