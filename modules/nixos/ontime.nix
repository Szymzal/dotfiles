{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mypackages.ontime;
in {
  options = {
    mypackages.ontime = {
      client.enable = mkEnableOption "Enable ontime client";
      server.enable = mkEnableOption "Enable ontime server";
    };
  };

  config = mkIf (cfg.client.enable || cfg.server.enable) {
    environment.systemPackages = with pkgs;
      optionals cfg.client.enable [
        ontime
      ];

    systemd.services."ontime" = mkIf cfg.server.enable {
      enable = true;
      serviceConfig = {
        Type = "simple";
        ExecStart = "${getExe' pkgs.ontime "ontime-server"}";
        Restart = "always";
        User = "ontime";
        Group = "ontime";
      };
    };

    users = mkIf cfg.server.enable {
      users."ontime" = {
        isNormalUser = true;
        group = "ontime";
        shell = getExe' pkgs.shadow "nologin";
      };
      groups."ontime" = {};
    };

    networking.firewall = {
      allowedUDPPorts = [8888 9999];
      allowedTCPPorts = [4001];
    };
  };
}
