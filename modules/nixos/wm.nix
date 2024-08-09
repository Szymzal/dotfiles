{ inputs, pkgs, lib, config, ... }:
with lib;
let
  hyprland_package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  cfg = config.mypackages.wm;
in
{
  options = {
    mypackages.wm = {
      enable = mkEnableOption "Enable Window Manager";
    };
  };

  config = mkIf cfg.enable {
    security.polkit.enable = true;

    mypackages.cachix = {
      substituters = [ "https://hyprland.cachix.org" ];
      public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };

    programs.hyprland = {
      enable = true;
      package = hyprland_package;
    };
  };
}
