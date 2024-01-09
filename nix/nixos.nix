{ self, nixpkgs, nixos-wsl, home-manager, ... }:

let 
  inherit (nixpkgs) lib;

  inputs = {
    inherit nixpkgs;
    inherit nixos-wsl;
    inherit home-manager;
  };

  generateConfiguration = hostname: { type, hostPlatform, ... }:
    lib.nixosSystem {
      modules = [
	{
	  nixpkgs.pkgs = self.pkgs.${hostPlatform};
	}
        (../hosts + "/${hostname}")
      ];
      specialArgs = {
        hostType = type;
	inherit inputs;
      };
    };

in
lib.mapAttrs
   generateConfiguration
   (lib.filterAttrs (_: host: host.type == "nixos") self.hosts)
