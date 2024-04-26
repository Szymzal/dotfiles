{ inputs, config, ... }:
let
  inherit (inputs) self;
in
{
  imports = [
    ./hardware-configuration.nix
    self.nixosModules.common
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

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

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
  mypackages.desktop.enable = true;
  mypackages.home-manager.enable = true;
  mypackages.wireshark.enable = true;
  mypackages.compression.enable = true;

  myusers.szymzal.enable = true;
}
