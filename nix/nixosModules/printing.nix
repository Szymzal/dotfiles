{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.mypackages.printing;
in
{
  options = {
    mypackages.printing = {
      enable = mkEnableOption "Enable printing";
    };
  };

  config = mkIf (cfg.enable)
  {
    services.avahi = {
      enable = true;
      nssmdns = true;
      openFirewall = true;
    };

    services.printing = {
      enable = true;
    };

    hardware.sane = {
      enable = true;
      brscan4 = {
        enable = true;
        netDevices = {
          Brother = { model = "DCP-J105"; ip = "172.20.60.5";  };
        };
      };
    };

    environment.systemPackages = with pkgs; [
      gnome.simple-scan
    ];

    mypackages.unfree.allowed = [
      "brscan4"
      "brscan4-etc-files"
      "brother-udev-rule-type1"
    ];

    mypackages.impermanence.directories = [
      "/etc/cups"
    ];
  };
}
