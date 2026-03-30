{
  self,
  inputs,
  ...
}: {
  perSystem = {system, ...}: let
    pkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
  in {
    packages.noctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;
      inherit ((builtins.fromJSON (builtins.readFile ./noctalia.json))) settings;
    };
  };

  flake.nixosModules.noctalia = {pkgs, ...}: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia
    ];

    persistence.user.directories = [".config/noctalia"];
  };
}
