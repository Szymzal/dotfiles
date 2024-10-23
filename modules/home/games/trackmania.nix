{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mypackages.games.trackmania;
in {
  options = {
    mypackages.games.trackmania = {
      enable = mkEnableOption "Enable Trackmania";
    };
  };

  config = mkIf cfg.enable {
    mypackages.impermanence.directories = [
      {
        directory = "Documents/Trackmania";
        method = "symlink";
      }
    ];
  };
}
