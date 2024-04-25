{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.mypackages.screenshot;
in
{
  options = {
    mypackages.screenshot = {
      enable = mkEnableOption "Enable screenshotting tool";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      grim
      slurp
      satty
    ];

    mypackages.impermanence = {
      directories = [
        ".config/satty"
        # TODO: make configurable path
        "Pictures/Screenshots"
      ];
    };
  };
}
