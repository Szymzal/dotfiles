{
  lib,
  config,
  ...
}:
with lib; let
  myLib = config.lib.myLib;
in {
  config = mkIf (myLib.isEnabledOptionOnHomeConfig "mypackages.file-explorer.enable") {
    # xdg.menus.enable = true;
  };
}
