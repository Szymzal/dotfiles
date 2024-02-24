{ pkgs, lib, config, ... }: 
with lib;
let
  # TODO: option to provide monitors file
  monitorsXmlContent = builtins.readFile ./monitors.xml;
  monitorsConfig = pkgs.writeText "gdm_monitors.xml" monitorsXmlContent;
  cfg = config.mypackages.dm;
in
{
  options = {
    mypackages.dm = {
      enable = mkEnableOption "Enable Display Manager";
    };
  };

  config = mkIf cfg.enable {
    mypackages.wm.enable = mkDefault true;

    systemd.tmpfiles.rules = [
      "L+ /run/gdm/.config/monitors.xml - - - - ${monitorsConfig}"
    ];

    services.xserver = {
      enable = true;
      xkb.layout = "pl";
      displayManager.gdm.enable = true;
      displayManager.gdm.wayland = true;
    };
  };
}
