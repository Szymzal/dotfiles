{ pkgs, config, lib, ... }: 
with lib;
let
  cfg = config.mypackages.steam;
in
{
  options = {
    mypackages.steam = {
      enable = mkEnableOption "Enable Steam";
    };
  };

  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = mkDefault true;
      dedicatedServer.openFirewall = mkDefault true;
    };

    environment.systemPackages = with pkgs; [
      steam-run
      steam-tui
      steamPackages.steamcmd
      (steam.override { extraPkgs = pkgs: [ mono gtk3 gtk3-x11 libgdiplus zlib ]; })
    ];

    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };
}
