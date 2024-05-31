{ lib, config, pkgs, inputs, ... }:
with lib;
let
  cfg = config.mypackages.games.minecraft;
in
{
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
      };
    };
  };

  config = mkIf (cfg.client.enable || cfg.server.enable) {
    environment.systemPackages = with pkgs; [
      jdk8
      jdk17
      jdk21
    ] ++ lib.optionals (cfg.client.enable) [
      prismlauncher
    ];

    services.minecraft-servers = mkIf cfg.server.enable {
      enable = true;
      eula = true;
      # dataDir = "/mnt/data/Games/Minecraft/Serwery/Linux/";
      servers = {
        games-datapack = {
          enable = true;
          autoStart = false;
          openFirewall = true;
          jvmOpts = "-Xmx4G -Xms4G";
          package = pkgs.fabricServers.fabric-1_20_6;
          serverProperties = {
            allow-flight = true;
            broadcast-console-to-ops = false;
            broadcast-rcon-to-ops = false;
            difficulty = "peaceful";
            enable-command-block = true;
            hide-online-players = true;
            max-players = 10;
            online-mode = false;
            spawn-protection = 0;
            simulation-distance = 8;
            view-distance = 16;
            motd = "Minigames server created for you :)";
          };
        };
      };
    };

    mypackages.impermanence.directories = lib.optionals (cfg.server.enable) [
      "/srv/minecraft"
    ];

    mypackages.unfree.allowed = mkIf (cfg.server.enable) [
      "minecraft-server"
    ];
  };
}
