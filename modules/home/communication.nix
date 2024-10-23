{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.mypackages.communication;
in {
  options = {
    mypackages.communication = {
      enable = mkEnableOption "Enable communication app (e.g. discord)";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      webcord
      element-desktop
    ];

    mypackages.impermanence = {
      directories = [
        ".config/WebCord"
        ".config/Element"
      ];
    };
  };
}
