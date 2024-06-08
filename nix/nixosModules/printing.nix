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
    services.printing = {
      enable = true;
      drivers = with pkgs; [ dcpj105lpr dcpj105cupswrapper ];
      logLevel = "debug";
    };

    mypackages.impermanence.directories = [
      "/etc/cups"
    ];
  };
}
