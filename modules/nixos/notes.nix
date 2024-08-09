{ lib, config, ... }:
with lib;
let
  myLib = config.lib.myLib;
in
{
  mypackages.unfree.allowed = mkIf ((myLib.isEnabledOptionOnHomeConfig "mypackages.notes.enable") && config.home-manager.useGlobalPkgs) [
    "obsidian"
  ];
}
