{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mypackages.xbox;
in {
  options = {
    mypackages.xbox = {
      enable = mkEnableOption "Enable support for xbox one/series controllers";
    };
  };

  config = mkIf cfg.enable {
    hardware.xone.enable = true;

    mypackages.unfree.allowed = [
      "xow_dongle-firmware"
    ];
  };
}
