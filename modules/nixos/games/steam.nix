{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mypackages.games.steam;
in {
  options = {
    mypackages.games.steam = {
      enable = mkEnableOption "Enable Steam launcher";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      steamtinkerlaunch
      protonup
      mangohud
    ];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      protontricks.enable = true;
      gamescopeSession.enable = true;
      dedicatedServer.openFirewall = true;
    };
    programs.gamemode.enable = true;
    programs.gamescope.enable = true;

    mypackages.unfree.allowed = [
      "steam"
      "steam-original"
      "steam-run"
    ];
  };
}
