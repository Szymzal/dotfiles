{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mypackages.games.factorio;
in {
  options = {
    mypackages.games.factorio = {
      enable = mkEnableOption "Enable Factorio";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedUDPPorts = [
      34197
    ];
  };
}
