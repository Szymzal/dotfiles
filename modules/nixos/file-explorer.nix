{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  myLib = config.lib.myLib;
in {
  config = mkIf (myLib.isEnabledOptionOnHomeConfig "mypackages.file-explorer.enable") {
    programs.dconf.enable = true;

    programs.thunar = {
      enable = true;
      plugins = with pkgs; [
        xfce.thunar-archive-plugin
      ];
    };

    services.gvfs.enable = true;
  };
}
