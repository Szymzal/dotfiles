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
      # krita

      # FIX: https://github.com/NixOS/nixpkgs/issues/348386
      gimp
      inkscape
    ];

    mypackages.impermanence = {
      directories = [
        # ".local/share/krita"
        ".config/GIMP"
        ".config/inkscape"
        "Pictures"
      ];
    };
  };
}
