{ lib, osConfig, ... }:
with lib;
let
  cfg = osConfig.mypackages.games.lutris;
in
{
  config = mkIf cfg.enable {
    mypackages.impermanence.directories = [
      {
        directory = ".config/steamtinkerlaunch";
        method = "symlink";
      }
      {
        directory = ".local/share/Steam";
        method = "symlink";
      }
      {
        directory = ".local/share/lutris";
        method = "symlink";
      }
      {
        directory = "Games";
        method = "symlink";
      }
    ];
  };
}
