{ lib, config, ... }:
with lib;
let
  cfg = config.mypackages.games.ets2;
in
{
  options = {
    mypackages.games.ets2 = {
      enable = mkEnableOption "Enable Euro Truck Simulator 2";
    };
  };

  config = mkIf cfg.enable {
    mypackages.impermanence.directories = [
      {
        directory = ".local/share/Euro Truck Simulator 2";
        method = "symlink";
      }
    ];
  };
}
