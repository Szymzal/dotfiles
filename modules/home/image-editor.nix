{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.mypackages.image-editors;
in {
  options = {
    mypackages.image-editors = {
      enable = mkEnableOption "Enable image editors";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [
        inkscape
      ]
      ++ (with pkgs.pkgs-unstable; [
        gimp3
      ]);

    mypackages.impermanence = {
      directories = [
        ".config/GIMP"
        ".config/inkscape"
        "Pictures"
      ];
    };
  };
}
