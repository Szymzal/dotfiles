{ inputs, pkgs, ... }:
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

  mypackages = {
    networkmanager = {
      enable = true;
      hostName = "machine";
    };
    gc.enable = true;
    editor.enable = true;
    clipboard.enable = true;
    git.enable = true;
    multiTerminal.enable = true;
    cachix.enable = true;

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
          scale = 1;
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
          scale = 1;
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
    bottles.enable = false;
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
      };
      iconTheme = {
        name = "Papirus";
        package = pkgs.papirus-icon-theme;
      };
    };
    mouse.enable = true;
    network-tools.enable = true;
    games.minecraft = {
      client.enable = true;
      server.enable = true;
    };
    casparcg.enable = true;
  };

  myusers.szymzal.enable = true;
}
