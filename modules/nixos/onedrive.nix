{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mypackages.onedrive;
in {
  options = {
    mypackages.onedrive = {
      enable = mkEnableOption "Enable OneDrive";
    };
  };

  config = mkIf cfg.enable {
    services.onedrive.enable = true;
  };
}
