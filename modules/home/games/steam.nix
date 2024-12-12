{
  lib,
  osConfig,
  ...
}:
with lib; let
  cfg = osConfig.mypackages.games.steam;
in {
  config = mkIf cfg.enable {
    home.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
    };

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
        directory = "Games";
        method = "symlink";
      }
    ];
  };
}
