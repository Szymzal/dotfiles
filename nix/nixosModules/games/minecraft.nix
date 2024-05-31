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

    # services.minecraft-servers = mkIf cfg.server.enable {
    #   enable = true;
    #   eula = true;
    # };
  };
}
