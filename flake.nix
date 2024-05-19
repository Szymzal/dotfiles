{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flakelight = {
      url = "github:nix-community/flakelight";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-snippets = {
      url = "github:garymjr/nvim-snippets";
      flake = false;
    };

    luarocks-nvim = {
      url = "github:vhyrro/luarocks.nvim";
      flake = false;
    };
  };

  outputs = { flakelight, ... }@inputs:
    flakelight ./. ({ lib, ... }: {
      inherit inputs;
      systems = lib.systems.flakeExposed;
    });
}
