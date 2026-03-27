{inputs, ...}: {
  perSystem = {system, ...}: let
    pkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
  in {
    packages.noctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;
      settings = {};
    };
  };
}
