{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.mypackages.screenshot;
in
{
  options = {
    mypackages.screenshot = {
      enable = mkEnableOption "Enable screenshotting tool";
      savePicturesPath = mkOption {
        default = "Pictures/Screenshots";
        example = "Pictures/Screenshots";
        description = "Path to directory for screenshots (only in /home/{user} directory)";
        type = types.str;
      };
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
        cfg.savePicturesPath
      ];
    };
  };
}
