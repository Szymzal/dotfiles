{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    flakelight = {
      url = "github:nix-community/flakelight";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    stylix.url = "github:danth/stylix/release-25.05";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    flatpak.url = "github:gmodena/nix-flatpak/latest";
    nvf.url = "github:NotAShelf/nvf";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    astal.url = "github:Aylur/astal";
    hyprsplit = {
      url = "github:shezdy/hyprsplit";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = {flakelight, ...} @ inputs: (flakelight ./. ({lib, ...}: {
    inherit inputs;

    outputs = {
      overlay = _: pkgs: (import ./pkgs {
        inherit pkgs;
        pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
      });
    };

    perSystem = pkgs: {
      packages.default =
        (inputs.nvf.lib.neovimConfiguration (let
          pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
        in {
          pkgs = pkgs-unstable;
          modules = [
            (import ./modules/shared/nvf {pkgs = pkgs-unstable;})
          ];
        }))
        .neovim;
    };

    withOverlays = [
      inputs.nix-minecraft.overlay
      (_: pkgs: (import ./pkgs {
        inherit pkgs;
        pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
      }))
    ];
    systems = lib.systems.flakeExposed;
  }));
}
