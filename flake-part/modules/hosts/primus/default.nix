{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.primus = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.primusConfiguration
    ];
  };
}
