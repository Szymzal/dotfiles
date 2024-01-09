{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      allSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
      ];
    in
    {
      hosts = import ./nix/hosts.nix;
      pkgs = allSystems (system: import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
	};
      });

      nixosConfigurations = import ./nix/nixos.nix inputs;
    };
}
