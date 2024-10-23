{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mypackages.mouse;
in {
  options = {
    mypackages.mouse = {
      enable = mkEnableOption "Enable mouse software";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      piper
    ];

    services.ratbagd.enable = true;
  };
}
