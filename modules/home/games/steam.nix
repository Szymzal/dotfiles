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
      ".config/steamtinkerlaunch"
      ".local/share/Steam"
      ".steam"
      "Games"
    ];
  };
}
