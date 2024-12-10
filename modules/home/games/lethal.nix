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
    environment.systemPackages = with pkgs; [
      # Mod loader
      r2modman
    ];
  };
}
