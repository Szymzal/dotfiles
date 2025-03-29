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
          glfw3-minecraft = glfw3-minecraft.overrideAttrs (attrs: let
            patchesGit = pkgs.fetchFromGitHub {
              owner = "BoyOrigin";
              repo = "glfw-wayland";
              rev = "f62b4ae8f93149fd754cadecd51d8b1a07d20522";
              hash = "sha256-kvWP34rOD4HSTvnKb33nvVquTGZoqP8/l+8XQ0h3b7Y=";
            };
          in {
            patches =
              attrs.patches
              ++ [
                "${patchesGit}/patches/0001-Key-Modifiers-Fix.patch"
                "${patchesGit}/patches/0002-Fix-duplicate-pointer-scroll-events.patch"
                "${patchesGit}/patches/0004-Fix-Window-size-on-unset-fullscreen.patch"
                "${patchesGit}/patches/0005-Avoid-error-on-startup.patch"
              ];
          });
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
