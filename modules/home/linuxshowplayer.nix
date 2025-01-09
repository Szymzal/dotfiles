{
  lib,
  config,
  pkgs,
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
    home.packages = with pkgs; [
      linux-show-player
    ];

    mypackages.impermanence.directories = [
      ".config/LinuxShowPlayer"
      ".local/share/LinuxShowPlayer"
    ];
  };
}
