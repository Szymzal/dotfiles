{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mypackages.sunshine;
in {
  options = {
    mypackages.sunshine = {
      enable = mkEnableOption "Enable sunshine";
    };
  };

  config = mkIf cfg.enable {
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };
  };
}
