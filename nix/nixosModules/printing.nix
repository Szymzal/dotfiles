{ lib, config, ... }:
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

    mypackages.impermanence.directories = [
      "/etc/cups"
    ];
  };
}
