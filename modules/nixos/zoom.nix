{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  myLib = config.lib.myLib;
in {
  config = mkIf (myLib.isEnabledOptionOnHomeConfig "mypackages.zoom.enable") {
    mypackages.unfree.allowed = mkIf (config.home-manager.useGlobalPkgs) [
      "zoom"
    ];

    systemd.tmpfiles.rules = [
      "L+ /usr/libexec/xdg-desktop-portal - - - - ${pkgs.xdg-desktop-portal}/libexec/xdg-desktop-portal"
    ];
  };
}
