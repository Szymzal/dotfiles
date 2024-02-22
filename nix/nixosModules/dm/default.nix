{ pkgs, ... }: 
let
  monitorsXmlContent = builtins.readFile ./monitors.xml;
  monitorsConfig = pkgs.writeText "gdm_monitors.xml" monitorsXmlContent;
in
{
  systemd.tmpfiles.rules = [
    "L+ /run/gdm/.config/monitors.xml - - - - ${monitorsConfig}"
  ];

  services.xserver = {
    enable = true;
    xkb.layout = "pl";
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;
  };

}
