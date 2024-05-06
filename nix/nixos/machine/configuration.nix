{ inputs, ... }:
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

  time.timeZone = "Europe/Warsaw";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    keyMap = "pl";
  };

  networking.hostName = "machine";
  networking.networkmanager.enable = true;

  # time.hardwareClockInLocalTime = true;

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
      spec = {
        connector = "DP-1";
        vendor = "AOC";
        model = "27G2G4";
        serial = "0x0000b8af";
      };
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
      spec = {
        connector = "HDMI-A-1";
        vendor = "IVM";
        model = "PL2470H";
        serial = "0x0000009a";
      };
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
  mypackages.dm.enable = true;
  mypackages.home-manager.enable = true;
  mypackages.wireshark.enable = true;
  mypackages.compression.enable = true;
  mypackages.nix-helpers.enable = true;
  mypackages.android.enable = true;
  mypackages.xbox.enable = true;
  mypackages.nvidia.enable = true;

  myusers.szymzal.enable = true;
}
