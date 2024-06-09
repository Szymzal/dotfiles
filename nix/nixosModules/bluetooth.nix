{ lib, config, ... }:
with lib;
let
  cfg = config.mypackages.bluetooth;
in
{
  options = {
    mypackages.bluetooth = {
      enable = mkEnableOption "Enable bluetooth manager";
    };
  };

  config = mkIf cfg.enable {
    services.blueman.enable = true;
  };
}
