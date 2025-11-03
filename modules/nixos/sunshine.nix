{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mypackages.sunshine;
in {
  options = {
    mypackages.sunshine = {
      enable = mkEnableOption "Enable sunshine";
    };
  };

  config = mkIf cfg.enable {
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
      settings = {
        output_name = 1;
      };
      applications = {
        apps = [
          {
            name = "Desktop";
            image-path = "desktop.png";
            prep-cmd = [
              {
                do = "${getExe pkgs.way-displays} -s DISABLED HDMI-A-1";
                undo = "${getExe pkgs.way-displays} -d DISABLED HDMI-A-1";
              }
              {
                do = "${getExe' config.programs.hyprland.package "hyprctl"} dispatch split:grabroguewindows";
                undo = "";
              }
            ];
          }
          {
            name = "Steam Big Picture";
            detached = [
              "setsid steam steam://open/bigpicture"
            ];
            image-path = "steam.png";
          }
        ];
      };
    };
  };
}
