{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.mypackages.games.minecraft;
in {
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];

  options = {
    mypackages.games.minecraft = {
      client = {
        enable = mkEnableOption "Enable Minecraft Client";
      };
      server = {
        enable = mkEnableOption "Enable Minecraft Server";
        servers = mkOption {
          type = types.attrs;
          default = {};
          description = "Servers to configure";
        };
      };
    };
  };

  config = mkIf (cfg.client.enable || cfg.server.enable) {
    environment.systemPackages = with pkgs;
      [
        jdk8
        jdk17
        jdk21
      ]
      ++ lib.optionals (cfg.client.enable) [
        prismlauncher
      ];

    systemd.services =
      lib.mapAttrs' (
        name: conf: {
          name = "minecraft-server-${name}";
          value = {
            startLimitIntervalSec = lib.mkForce 10;
          };
        }
      )
      cfg.server.servers;

    services.minecraft-servers = mkIf cfg.server.enable {
      enable = true;
      eula = true;
      servers = cfg.server.servers;
    };

    mypackages.impermanence.directories = lib.optionals (cfg.server.enable) [
      "/srv/minecraft"
    ];

    mypackages.unfree.allowed = mkIf (cfg.server.enable) [
      "minecraft-server"
    ];
  };
}
