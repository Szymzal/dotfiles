{
  lib,
  config,
  # pkgs,
  ...
}:
with lib; let
  cfg = config.mypackages.linux-show-player;
in {
  options = {
    mypackages.linux-show-player = {
      enable = mkEnableOption "Enable Linux Show Player";
    };
  };

  config = mkIf cfg.enable {
    mypackages.flatpak = {
      enable = true;
      packages = [
        "org.linuxshowplayer.LinuxShowPlayer"
      ];
    };

    mypackages.impermanence.directories = [
      ".config/LinuxShowPlayer"
      ".local/share/LinuxShowPlayer"
    ];
  };
}
