{ lib, config, ... }:
with lib;
let
  cfg = config.mypackages.games.terraria;
in
{
  options = {
    mypackages.games.terraria = {
      enable = mkEnableOption "Enable Terraria";
    };
  };

  config = mkIf cfg.enable {
    mypackages.impermanence.directories = [
      {
        directory = ".local/share/Terraria";
        method = "symlink";
      }
    ];
  };
}
