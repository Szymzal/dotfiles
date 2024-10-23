{
  lib,
  config,
  ...
}:
with lib; let
  myLib = config.lib.myLib;
in {
  mypackages.unfree.allowed = mkIf (myLib.isEnabledOptionOnHomeConfig "mypackages.coding.enable") [
    "intelephense"
  ];
}
