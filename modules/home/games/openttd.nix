{ config, lib, ... }:
with lib;
let
  cfg = config.mypackages.games.openttd;
in
{
  options = {
    mypackages.games.openttd = {
      enable = mkEnableOption "Enable OpenTTD game";
    };
  };

  config = mkIf cfg.enable {
    mypackages.impermanence.directories = [
      ".local/share/openttd"
    ];
  };
}
