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
          symlinks = {
            # nix run github:Infinidoge/nix-minecraft#nix-modrinth-prefetch -- versionid
            mods = pkgs.linkFarmFromDrvs "mods" (builtins.attrValues {
              SkinRestorer = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/ghrZDhGW/versions/SMwzLRyJ/skin-restorer-1.2.4.jar"; sha512 = "316df038d4209ae6d1586a9b4f001b5f8e9fc26214c6784bd967c9781099996b76417cebbacc726cc410a54e8fa5328da7797c5da8912b298811bb42f008a6d6"; };
              Lithium = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/bAbb09VF/lithium-fabric-mc1.20.6-0.12.3.jar"; sha512 = "cda611c684636309322f0f406c9f0146552019e5dd10a53b8942c1b0d9df47e2d39abed557cf84e58348c3ad127c83c7e370f1ac79d9a6fad21d845eba4941ed"; };
              FerriteCore = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/uXXizFIs/versions/i9RcCdZv/ferritecore-6.1.1-fabric.jar"; sha512 = "d07ebedcab096389ceaf17dd7463c165c9455c24300d494e1f394c3e4ed2d43686e35a4fd87280eda2bf4c96695da3e0183a3474016c8d7d13b56c6e04c2acef"; };
              ModernFix = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/nmDcB62a/versions/xlt4bcjj/modernfix-fabric-5.17.3%2Bmc1.20.6.jar"; sha512 = "7aea7801f240a011120d32d4b6e7e2ab999b154c5c4f40ef72b1b784e9b8a0d99325a877db26036114f4c46f90cbdae9bfd709bb552ad386ea81d7548a3e5c8e"; };
              ServerCore = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/4WWQxlQP/versions/aU1Fp6PB/servercore-fabric-1.5.2%2B1.20.6.jar"; sha512 = "74d58f2f2c35818259f7c7eda1ddd636c2045b8dc864f8e949ad91f154e9dbce1df22cacd7ce9be873779ae77dafecd0a2ca98d1751ad0c259510e9b819fe618"; };
              VMP = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/wnEe9KBa/versions/83ET13o3/vmp-fabric-mc1.20.6-0.2.0%2Bbeta.7.155-all.jar"; sha512 = "3b94d1cb477bfadfa7315664571e745029f764d168511b2848f0a3cb8aaf54da8f12caa921a1e7abf2c5906326fb1159a8fd457b35281a0fb4221fbb98465bcb"; };
              C2ME = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/VSNURh3q/versions/1jjyJyVe/c2me-fabric-mc1.20.6-0.2.0%2Balpha.11.95.jar"; sha512 = "ea496fb616bfc65d00e067bfc46a5d409c13d3ec187397ebe0cced59badd27b73cb818f9c769266d99c25bc3ae32fc4309e4f716be9bb3209171dda49f797b54"; };
              FabricAPI = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/MtIGbixh/fabric-api-0.99.4%2B1.20.6.jar"; sha512 = "8a016df8989b082694d484f51c7d2207eca3af722cfe573dad093f2087832117e7a4c89a969eb84aaa6460956dec6352494a425a7e6e46c26eb8d5bc779da2bf"; };
              Axiom = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/N6n5dqoA/versions/sJP1pto6/Axiom-3.0.0-for-MC1.20.6.jar"; sha512 = "b5cb5edb5705534c86243c03735cea4c808161b84bbcbd638b86e16990c88a0ab6f2c56449d218ce6c1ceb7ff194b43e3dae83f10123ce6bc3bcea81ba2af1cc"; };
            });
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
