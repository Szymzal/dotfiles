{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.machine = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.machineConfiguration
    ];
  };
}
