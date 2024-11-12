{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mypackages.syncthing;
in {
  options = {
    mypackages.syncthing = {
      enable = mkEnableOption "Enable Syncthing";
    };
  };

  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      user = "szymzal";
      dataDir = "/home/szymzal/Documents";
      configDir = "/home/szymzal/.config/syncthing";
      overrideDevices = true;
      overrideFolders = true;
    };
  };
}
