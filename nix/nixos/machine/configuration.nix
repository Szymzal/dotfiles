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

  time.timeZone = "Europe/Warsaw";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    keyMap = "pl";
  };

  networking.hostName = "machine";
  networking.networkmanager.enable = true;

  time.hardwareClockInLocalTime = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  mypackages.gc.enable = true;
  mypackages.editor.enable = true;
  mypackages.clipboard.enable = true;
  mypackages.git.enable = true;
  mypackages.multiTerminal.enable = true;
  mypackages.cachix.enable = true;

  mypackages.monitors = [
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

  mypackages.impermanence = {
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

  mypackages.sound.enable = true;
  mypackages.fonts.enable = true;
  mypackages.shell.enable = true;
  mypackages.sops.enable = true;
  mypackages.wm.enable = true;
  mypackages.dm = {
    enable = true;
    wallpaper-path = /persist/nixos/wallpaper.jpg;
  };
  mypackages.home-manager.enable = true;
  mypackages.wireshark.enable = true;
  mypackages.compression.enable = true;
  mypackages.nix-helpers.enable = true;
  mypackages.android.enable = true;
  mypackages.xbox.enable = true;
  mypackages.nvidia.enable = true;
  mypackages.cd.enable = true;
  mypackages.ls.enable = true;
  mypackages.find.enable = true;
  mypackages.bottles.enable = false;
  mypackages.catppuccin-hyprcursor.enable = false;
  mypackages.theme = {
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
  mypackages.mouse.enable = true;
  mypackages.network-tools.enable = true;
  mypackages.games.minecraft = {
    client.enable = true;
    server.enable = true;
  };

  myusers.szymzal.enable = true;
}
