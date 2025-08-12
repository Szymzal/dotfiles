{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.mypackages.epic-games;
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs) system;
  };
in {
  options = {
    mypackages.epic-games = {
      enable = mkEnableOption "Enable Epic Games Store";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs-unstable; [
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
