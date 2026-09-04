{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.mypackages.games.lethalCompany;
in {
  options = {
    mypackages.games.lethalCompany = {
      enable = mkEnableOption "Enable mod manager/loader for Lethal Company";
    };
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Mod loader
      r2modman
    ];

    mypackages.impermanence.directories = [
      ".config/r2modmanPlus-local"
    ];
  };
}
