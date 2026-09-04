{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mypackages.connect;
in {
  options = {
    mypackages.connect = {
      enable = mkEnableOption "Enable KDE Connect";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall = rec {
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = allowedTCPPortRanges;
    };
  };
}
