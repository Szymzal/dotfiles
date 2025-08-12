{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mypackages.epic-games;
in {
  options = {
    mypackages.epic-games = {
      enable = mkEnableOption "Enable Epic Games Store";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (heroic.override {
        extraPkgs = pkgs: [
          pkgs.gamescope
          pkgs.gamemode
        ];
      })
    ];

    mypackages.bottles.enable = true;
    mypackages.impermanence.directories = [
      ".config/legendary"
    ];
  };
}
