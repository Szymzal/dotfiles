{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mypackages.games.rocket-league;
in {
  options = {
    mypackages.games.rocket-league = {
      enable = mkEnableOption "Enable Rocket League";
    };
  };

  config = mkIf cfg.enable {
    mypackages.impermanence.directories = [
      {
        directory = ".local/share/Rocket League";
        method = "symlink";
      }
    ];
  };
}
