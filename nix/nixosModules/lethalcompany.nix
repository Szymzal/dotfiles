{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.mypackages.games.lethalCompany;
in
{
  options = {
    mypackages.games.lethalCompany = {
      enable = mkEnableOption "Enable Steam and install mod manager/loader";
    };
  };

  config = mkIf cfg.enable {
    mypackages.steam.enable = true;

    environment.systemPackages = with pkgs; [
      # Mod loader
      r2modman
    ];
  };
}
