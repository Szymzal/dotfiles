{ lib, config, ... }: 
with lib;
let
  cfg = config.mypackages.desktop;
in
{
  options = {
    mypackages.desktop = {
      enable = mkEnableOption "Enable desktop";
    };
  };

  config = mkIf cfg.enable {
    security.polkit.enable = true;

    hardware.opengl = {
      enable = true;
    };

    hardware.xone.enable = true;
  };
}
