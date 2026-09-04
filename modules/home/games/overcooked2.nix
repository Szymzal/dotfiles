{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mypackages.games.overcooked2;
in {
  options = {
    mypackages.games.overcooked2 = {
      enable = mkEnableOption "Enable Overcooked2";
    };
  };

  config = mkIf cfg.enable {
    mypackages.impermanence.directories = [
      ".config/unity3d/Team17/Overcooked2"
    ];
  };
}
