{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.mypackages.viewers;
in {
  options = {
    mypackages.viewers = {
      enableAll = mkEnableOption "Enable all viewers";
      video = {
        enable = mkEnableOption "Enable video viewer";
      };
      image = {
        enable = mkEnableOption "Enable image viewer";
      };
    };
  };

  config = mkIf (cfg.enableAll || cfg.video.enable || cfg.image.enable) {
    home.packages =
      []
      ++ optionals (cfg.enableAll || cfg.video.enable) [
        pkgs.mpv
      ]
      ++ optionals (cfg.enableAll || cfg.image.enable) [
        pkgs.feh
      ];

    mypackages.impermanence = {
      directories =
        []
        ++ optionals (cfg.enableAll || cfg.video.enable) [
          ".config/mpv"
        ];
    };
  };
}
