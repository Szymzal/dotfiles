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

    ts-comments-nvim = {
      url = "github:folke/ts-comments.nvim";
      flake = false;
    };

    nvim-snippets = {
      url = "github:garymjr/nvim-snippets";
      flake = false;
    };

    luarocks-nvim = {
      url = "github:vhyrro/luarocks.nvim";
      flake = false;
    };

    stylix.url = "github:danth/stylix";

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
  };

  outputs = { flakelight, ... }@inputs:
    flakelight ./. ({ lib, ... }: {
      inherit inputs;
      withOverlays = [
        inputs.nix-minecraft.overlay
        (_: pkgs: (import ./pkgs { inherit pkgs; }))
      ];
      systems = lib.systems.flakeExposed;
    });
}
