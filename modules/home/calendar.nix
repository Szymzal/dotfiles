{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.mypackages.calendar;
in
{
  options = {
    mypackages.calendar = {
      enable = mkEnableOption "Enable cd replacement";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      merkuro
    ];

    mypackages.impermanence.directories = [
      ".config/KDE"
    ];
  };
}
