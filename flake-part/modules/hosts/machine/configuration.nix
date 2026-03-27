{self, ...}: {
  flake.nixosModules.machineConfiguration = {...}: {
    imports = [
      self.nixosModules.machineHardware
      self.nixosModules.niri
    ];

    nix.settings.experimental-features = ["nix-command" "flakes"];
  };
}
