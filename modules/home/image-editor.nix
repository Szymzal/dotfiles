{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
with lib; let
  cfg = config.mypackages.image-editors;
  pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
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
      ++ (with pkgs-unstable; [
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
