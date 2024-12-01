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
        ((glfw.overrideAttrs
            (attrs: let
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
            }))
          .override {
            withMinecraftPatch = true;
          })
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
