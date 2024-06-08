{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.mypackages.file-explorer;
in
{
  options = {
    mypackages.file-explorer = {
      enable = mkEnableOption "Enable file explorer";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      xfce.thunar
      xfce.xfconf
    ];

    mypackages.impermanence = {
      directories = [
        ".config/gtk-3.0/bookmarks"
        ".config/Thunar"
        ".config/xfce4"
      ];
    };
  };
}
