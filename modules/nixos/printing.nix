{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mypackages.printing;
in {
  options = {
    mypackages.printing = {
      enable = mkEnableOption "Enable printing";
    };
  };

  config =
    mkIf (cfg.enable)
    {
      services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };

      services.printing = {
        enable = true;
      };

      hardware.sane = {
        enable = true;
        openFirewall = true;
        # TODO: Make is declarable
        brscan4 = {
          enable = true;
          netDevices = {
            Brother = {
              name = "Home";
              model = "DCP-J105";
              ip = "10.128.64.5";
            };
          };
        };
      };

      environment.systemPackages = with pkgs; [
        cups-pdf-to-pdf
        simple-scan
        system-config-printer
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
