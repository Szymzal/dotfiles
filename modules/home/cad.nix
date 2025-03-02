{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mypackages.cad;
in {
  options = {
    mypackages.cad = {
      enable = mkEnableOption "Enable 2D CAD software";
    };
  };

  config = mkIf cfg.enable {
    mypackages.impermanence.directories = [
    ];

    home.packages = with pkgs; [
      gstarcad
    ];
  };
}
