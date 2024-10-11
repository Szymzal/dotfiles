{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.mypackages.notes;
in
{
  options = {
    mypackages.notes = {
      enable = mkEnableOption "Enable note taking app";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      obsidian
    ];

    mypackages.impermanence = {
      directories = [
        ".config/obsidian"
        "Notes"
      ];
    };

    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "obsidian"
      ];
  };
}
