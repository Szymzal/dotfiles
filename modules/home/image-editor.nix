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
      enable = mkEnableOption "Enable file explorer";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      krita
      gimp
      inkscape
    ];

    mypackages.impermanence = {
      directories = [
        ".local/share/krita"
        ".config/GIMP"
        ".config/inkscape"
        "Pictures"
      ];
    };
  };
}
