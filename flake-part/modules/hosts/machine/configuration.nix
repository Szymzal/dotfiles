{self, ...}: {
  flake.nixosModules.machineConfiguration = {...}: {
    imports = [
      self.nixosModules.options
      self.nixosModules.machineHardware
      self.nixosModules.niri
    ];

    nix.settings.experimental-features = ["nix-command" "flakes"];

    services.dbus.implementation = "broker";

    boot.plymouth.enable = true;

    persistence = {
      fileSystem = "/persist";
      system = {
        persistenceDir = "/persist/system";
      };
      user = {
        username = "szymzal";
        persistenceDir = "/persist/home";
      };
      disableSudoLecture = true;
      wipeOnBoot = {
        enable = true;
        virtualGroup = "/dev/root_vg";
        rootSubvolume = "root";
        daysToDeleteOldRoots = 7;
      };
    };
  };
}
