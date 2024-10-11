{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.mypackages.playit;
in {
  options = {
    mypackages.playit = {
      enable = mkEnableOption "Enable playit agent";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      playit-agent
    ];

    mypackages.impermanence.directories = [
      ".config/playit_gg"
    ];
  };
}
