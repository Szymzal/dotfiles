{ lib, config, pkgs, ... }: 
with lib;
let
  cfg = config.mypackages.status-bar;
in
{
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
                months = "<span color='#ffead3'><b>{}</b></span>";
                days = "<span color='#ecc6d9'><b>{}</b></span>";
                weeks = "<span color='#99ffdd'><b>W{}</b></span>";
                weekdays = "<span color='#ffcc66'><b>{}</b></span>";
                today = "<span color='#ff6699'><b><u>{}</u></b></span>";
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
          background: rgba(43, 48, 59, 0.5);
          border-bottom: 3px solid rgba(100, 114, 125, 0.5);
          color: white;
        }

        tooltip {
          background: rgba(43, 48, 59, 0.5);
          border: 1px solid rgba(100, 114, 125, 0.5);
        }

        tooltip label {
          color: white;
        }

        #workspaces button {
          padding: 0 5px;
          background: transparent;
          color: white;
          border-bottom: 3px solid transparent;
        }

        #workspaces button.focused {
          background: #64727D;
          border-bottom: 3px solid white;
        }

        #mode, #clock, #temperature, #pulseaudio {
          margin-left: 5px;
          padding: 0 10px;
        }

        #mode {
          background: #64727D;
          border-bottom: 3px solid white;
        }

        #clock {
          background-color: #64727D;
        }

        #temperature {
          background-color: orange;
        }

        #pulseaudio {
          background-color: green;
        }
      '';
    };
  };
}
