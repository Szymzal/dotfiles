{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.mypackages.image-editors;
in
{
  options = {
    mypackages.image-editors = {
      enable = mkEnableOption "Enable file explorer";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gimp
      inkscape
    ];

    mypackages.impermanence = {
      directories = [
        ".config/GIMP"
        ".config/inkscape"
      ];
    };
  };
}
