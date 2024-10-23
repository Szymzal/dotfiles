{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mypackages.networkmanager;
in {
  options = {
    mypackages.networkmanager = {
      enable = mkEnableOption "Enable Network Manager";
      hostName = mkOption {
        default = "pc";
        example = "homePC";
        description = "Computer name on local network";
        type = types.str;
      };
    };
  };

  config = mkIf cfg.enable {
    networking.hostName = cfg.hostName;
    networking.networkmanager.enable = true;
  };
}
