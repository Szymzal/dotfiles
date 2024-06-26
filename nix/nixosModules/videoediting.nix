{ lib, config, ... }:
with lib;
let
  myLib = config.lib.myLib;
in
{
  mypackages.unfree.allowed = mkIf ((myLib.isEnabledOptionOnHomeConfig "mypackages.video-editing.enable") && config.home-manager.useGlobalPkgs) [
    "davinci-resolve"
  ];
}
