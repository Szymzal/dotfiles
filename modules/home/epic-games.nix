{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.mypackages.epic-games;
in {
  options = {
    mypackages.epic-games = {
      enable = mkEnableOption "Enable Epic Games Store";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      legendary-gl
    ];

    mypackages.impermanence.directories = [
      ".config/legendary"
    ];
  };
}
