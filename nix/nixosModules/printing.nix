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

  config = mkIf (cfg.enable) {
    services.printing = {
      enable = true;
      drivers = with pkgs; [ gutenprint brgenml1cupswrapper brgenml1lpr ];
    };

    mypackages.unfree.allowed = [
      "brgenml1lpr"
      "brgenml1cupswrapper"
    ];
  };
}
