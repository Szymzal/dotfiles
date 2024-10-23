{
  lib,
  config,
  ...
}:
with lib; let
  myLib = config.lib.myLib;
in {
  config = mkIf ((myLib.isEnabledOptionOnHomeConfig "mypackages.notes.enable") && config.home-manager.useGlobalPkgs) {
    programs.foot = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
