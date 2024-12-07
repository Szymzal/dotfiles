{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mypackages.games.lutris;
in {
  options = {
    mypackages.games.lutris = {
      enable = mkEnableOption "Enable Lutris launcher";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lutris
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
