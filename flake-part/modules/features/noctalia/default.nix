{inputs, ...}: {
  perSystem = {system, ...}: let
    pkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
  in {
    packages.noctalia = pkgs.noctalia;
  };

  flake.nixosModules.noctalia = {...}: {
    imports = [
      inputs.noctalia.nixosModules.default
    ];

    programs.noctalia = {
      enable = true;
      recommendedServices.enable = true;
      systemd.enable = true;
    };

    nix.settings = {
      extra-substituters = ["https://noctalia.cachix.org"];
      extra-trusted-public-keys = ["noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="];
    };

    persistence.user.directories = [".config/noctalia"];
  };
}
