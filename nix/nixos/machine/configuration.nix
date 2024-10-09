{ lib, inputs, pkgs, ... }:
let
  inherit (inputs) self;
in
{
  imports = [
    ./hardware-configuration.nix
    self.nixosModules.modules
  ];

  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
  };

  boot.supportedFilesystems = [ "ntfs" ];

  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages_6_10;

  boot.kernelParams = [
    "reboot=acpi"
  ];

  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/8A48821948820463";
    fsType = "ntfs-3g";
    options = [ "rw" "gid=100" "uid=1000" "noatime" ];
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "pl_PL.UTF-8";
    };
  };

  console = {
    keyMap = "pl";
  };

  time.timeZone = "Europe/Warsaw";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "65536";
    }
  ];

  networking = {
    firewall.enable = true;
    nftables.enable = true;
    interfaces.enp3s0.wakeOnLan.enable = true;
  };

  environment.systemPackages = with pkgs; [
    btop
  ];

  mypackages = {
    ssh.enable = true;
    unfree.allowed = [
      "forge-loader"
    ];
    networkmanager = {
      enable = true;
      hostName = "machine";
    };
    gc.enable = true;
    tailscale.enable = true;
    editor.enable = true;
    clipboard.enable = true;
    git.enable = true;
    multiTerminal.enable = true;
    cachix.enable = true;
    cuda.enable = true;

    monitors = [
      {
        enable = true;
        primary = true;
        connector = "DP-1";
        position = {
          x = 0;
          y = 0;
        };
        mode = {
          width = 1920;
          height = 1080;
          rate = 144.00101;
          scale = 1.0;
        };
      }
      {
        enable = true;
        connector = "HDMI-A-1";
        position = {
          x = 1920;
          y = 0;
        };
        mode = {
          width = 1920;
          height = 1080;
          rate = 143.99800;
          scale = 1.0;
        };
      }
    ];

    impermanence = {
      enable = true;
      fileSystem = "/persist";
      persistenceDir = "/persist/system";
      disableSudoLecture = true;
      wipeOnBoot = {
        enable = true;
        virtualGroup = "/dev/main_vg";
        rootSubvolume = "root";
        daysToDeleteOldRoots = 7;
      };
    };

    sound.enable = true;
    fonts.enable = true;
    shell.enable = true;
    sops = {
      enable = true;
      defaultSopsFile = ../../../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";
      keyFile = "/persist/home/szymzal/.config/sops/age/keys.txt";
      secrets = {
        password = {
          neededForUsers = true;
        };
      };
    };
    wm.enable = true;
    dm = {
      enable = true;
      wallpaper-path = /persist/customization/wallpaper.jpg;
    };
    home-manager.enable = true;
    wireshark.enable = true;
    compression.enable = true;
    nix-helpers.enable = true;
    android.enable = true;
    printing.enable = true;
    bluetooth.enable = true;
    xbox.enable = true;
    nvidia = {
      enable = true;
      open.enable = false;
    };
    cd.enable = true;
    ls.enable = true;
    find.enable = true;
    bottles.enable = true;
    theme = {
      enable = true;
      prefer-dark-theme = true;
      theme = {
        base16-scheme-path = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      };
      cursorTheme = {
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
        size = 16;
        hyprcursor = {
          enable = true;
          name = "Bibata-Modern-Classic-hyprcursor";
          package = pkgs.bibata-hyprcursor;
        };
      };
      iconTheme = {
        name = "Papirus";
        package = pkgs.papirus-icon-theme;
      };
    };
    mouse.enable = true;
    network-tools.enable = true;
    flatpak.enable = true;
    games = {
      lutris.enable = true;
      minecraft = {
        client.enable = true;
        server = {
          enable = true;
          servers = (let
            copyFiles = (from: to: (let
              evalDir = (prefix: to: dir:
                (lib.mapAttrsToList
                  (path: type:
                    (let
                      diffPath = (builtins.replaceStrings [ "${prefix}" ] [ "" ] "${dir}");
                      diffPathRemovedDep = builtins.unsafeDiscardStringContext diffPath;
                    in (
                        if (type == "directory") then
                          (evalDir prefix to "${prefix}${diffPath}/${path}")
                        else
                          {
                            "${to}${diffPathRemovedDep}/${path}" = "${prefix}${diffPath}/${path}";
                          }
                      )
                    )
                  )
                  (builtins.readDir dir)
                )
              );
            in (
              lib.mergeAttrsList (lib.flatten (evalDir from to from))
            )));
          in {
            minecraft-1-20-survival = (let
              modpack = pkgs.fetchModrinthModpack {
                url = "https://cdn.modrinth.com/data/EGs3lC8D/versions/ZmjQ66hF/Prominence%20II%20Hasturian%20Era%203.0.5h.mrpack";
                hash = "sha512-gnWhh9ZVYNt21+Vt6E2aXgGWKb/28QnDIQJ4B2+5lruXSR8FyKqGDxd5+DZJDFhly3nb6T6rFfeXsjxzKR7Npg==";
                removeProjectIDs = [
                  "tJzrFuyy"
                ];
              };
            in {
              enable = true;
              autoStart = false;
              openFirewall = true;
              jvmOpts = "-Xmx8G -Xms8G";
              package = pkgs.fabricServers.fabric-1_20_1;
              serverProperties = {
                server-port = 25565;
                allow-flight = true;
                broadcast-console-to-ops = false;
                broadcast-rcon-to-ops = false;
                difficulty = "hard";
                enable-command-block = false;
                hide-online-players = true;
                max-players = 10;
                online-mode = true;
                spawn-protection = 0;
                simulation-distance = 8;
                view-distance = 16;
                motd = "Some survival";
              };
              # symlinks = {
              #   mods = "${modpack}/mods";
              # };
              # files = (copyFiles "${modpack}/config" "config")
              #   // (copyFiles "${modpack}/defaultconfigs" "defaultconfigs")
              #   // (copyFiles "${modpack}/mods" "mods");
            });
            CreateServer = {
              enable = true;
              autoStart = false;
              openFirewall = true;
              jvmOpts = "-Xmx8G -Xms8G";
              package = pkgs.fabricServers.fabric-1_20_1;
              serverProperties = {
                server-port = 25571;
                allow-flight = true;
                broadcast-console-to-ops = false;
                broadcast-rcon-to-ops = false;
                difficulty = "hard";
                enable-command-block = true;
                hide-online-players = true;
                max-players = 10;
                online-mode = true;
                spawn-protection = 0;
                simulation-distance = 8;
                view-distance = 16;
                motd = "Create Modpack Created by US :)";
              };
              symlinks = {
                mods = (
                let
                  modpack = pkgs.fetchModrinthModpack {
                    mrpackFile = ./CreateModpackv1.mrpack;
                  };
                in
                "${modpack}/mods"
                );
              };
            };
            TerraFirmaGreg = (let
              gameVersion = "1.20.x";
              modpackVersion = "0.7.12";
              modpack = pkgs.fetchzip {
                url = "https://github.com/TerraFirmaGreg-Team/Modpack-Modern/releases/download/${modpackVersion}/TerraFirmaGreg-${gameVersion}-${modpackVersion}-server.zip";
                hash = "sha256-k5OU6HBnf3Y9Zf7ZV/TA5ck2H/g7hnwW/0e/vYcn8wI=";
              };
            in {
              enable = true;
              autoStart = false;
              openFirewall = true;
              jvmOpts = "-Xmx4G -Xms4G";
              package = pkgs.forgeServers.forge-1_20_1.override {
                loaderVersion = "47.2.6";
                jre_headless = pkgs.jdk17;
              };
              serverProperties = {
                server-port = 25568;
                allow-flight = true;
                allow-nether = false;
                broadcast-console-to-ops = false;
                broadcast-rcon-to-ops = false;
                difficulty = "normal";
                level-type = "tfc\:overworld";
                max-chained-neighbor-updates = 1000000;
                max-players = 5;
                online-mode = true;
                spawn-protection = 0;
              };
              symlinks = {
                "mods" = "${modpack}/mods";
                "kubejs" = "${modpack}/kubejs";
              };
              files = (copyFiles "${modpack}/config" "config")
                // (copyFiles "${modpack}/defaultconfigs" "defaultconfigs");
            });
            games-datapack = {
              enable = true;
              autoStart = false;
              openFirewall = true;
              jvmOpts = "-Xmx4G -Xms4G";
              package = pkgs.fabricServers.fabric-1_20_6;
              serverProperties = {
                server-port = 25566;
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
            minecraft-1-21 = {
              enable = true;
              autoStart = false;
              openFirewall = true;
              jvmOpts = "-Xmx4G -Xms4G";
              package = pkgs.fabricServers.fabric-1_21.override {
                loaderVersion = "0.15.11";
              };
              serverProperties = {
                server-port = 25567;
                allow-flight = true;
                broadcast-console-to-ops = false;
                broadcast-rcon-to-ops = false;
                difficulty = "hard";
                enable-command-block = false;
                hide-online-players = true;
                max-players = 10;
                online-mode = true;
                spawn-protection = 0;
                simulation-distance = 8;
                view-distance = 16;
                motd = "Some survival";
              };
              symlinks = {
                mods = (
                let
                  modpack = pkgs.fetchModrinthModpack {
                    url = "https://cdn.modrinth.com/data/lezk3Nxv/versions/6DfeUJhQ/NMI%201.21%201.1.0.mrpack";
                    hash = "sha512-s4aHltlOta1RkPBCHQBwUYRysFAESXhD8uy4z6aJghyHCeuAd2KRQkQWouNgKhnH899b4+15RsbkmQJJSyr1RA==";
                    removeProjectIDs = [
                      "ZjwW8Q6n"
                      "2RuZIzOq"
                    ];
                  };
                in
                "${modpack}/mods"
                );
              };
            };
          });
        };
      };
    };
    casparcg.enable = false;
  };

  myusers.szymzal.enable = true;
}
