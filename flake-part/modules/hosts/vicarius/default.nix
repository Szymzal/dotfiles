{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.vicarius = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.vicariusConfiguration
    ];
  };
}
