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
        java.enable = mkEnableOption "Enable Minecraft Java Edition Client";
        bedrock.enable = mkEnableOption "Enable Minecraft Bedrock Client";
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

  config = mkIf (cfg.client.java.enable || cfg.client.bedrock.enable || cfg.server.enable) {
    environment.systemPackages = with pkgs;
      lib.optionals cfg.client.java.enable [
        (prismlauncher.override {
          gamemodeSupport = true;
          jdks = with pkgs; [
            jdk25
            jdk21
            jdk17
            jdk8
          ];
        })
      ];

    systemd.services =
      lib.mapAttrs' (
        name: _: {
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
      openFirewall = false;
      servers = cfg.server.servers;
      managementSystem = {
        tmux.enable = false;
        systemd-socket.enable = true;
      };
    };

    mypackages.impermanence.directories = lib.optionals cfg.server.enable [
      "/srv/minecraft"
    ];

    mypackages.unfree.allowed = mkIf cfg.server.enable [
      "minecraft-server"
    ];
  };
}
