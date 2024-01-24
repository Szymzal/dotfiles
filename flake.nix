{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flakelight = {
      url = "github:nix-community/flakelight";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { flakelight, ... }@inputs:
    flakelight ./. ({ lib, ... }: {
      inherit inputs;
      systems = lib.systems.flakeExposed;
    });
}
