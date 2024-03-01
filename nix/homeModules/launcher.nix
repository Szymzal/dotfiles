{ pkgs, lib, config, ... }: 
with lib;
let
  cfg = config.mypackages.launcher;
in
{
  options = {
    mypackages.launcher = {
      enable = mkEnableOption "Enable App/Power launcher";
    };
  };

  config = mkIf cfg.enable {
    programs.rofi = {
      enable = true;
    };

    home.packages = with pkgs; [
      rofi-power-menu
    ];
  };
}
