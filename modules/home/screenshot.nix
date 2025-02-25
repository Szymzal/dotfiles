{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
with lib; let
  cfg = config.mypackages.screenshot;
  pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in {
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
    home = {
      packages = with pkgs-unstable; [
        grimblast
      ];
    };

    programs.zsh.sessionVariables = {
      XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/${cfg.savePicturesPath}";
    };

    mypackages.impermanence = {
      directories = [
        cfg.savePicturesPath
      ];
    };
  };
}
