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
    programs.hyprland = {
      enable = true;
      package = hyprland_package;
    };
  };
}
