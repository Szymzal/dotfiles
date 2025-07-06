{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mypackages.qgis;
in {
  options = {
    mypackages.qgis = {
      enable = mkEnableOption "Enable QGIS";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      qgis
    ];

    mypackages.impermanence.directories = [
      ".local/share/QGIS"
    ];
  };
}
