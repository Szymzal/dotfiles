{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    flakelight = {
      url = "github:nix-community/flakelight";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";
    stylix.url = "github:danth/stylix/release-24.11";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    flatpak.url = "github:gmodena/nix-flatpak/latest";
    nvf.url = "github:NotAShelf/nvf";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    hyprland.url = "github:hyprwm/Hyprland/8c97cb7858e5d6c35d1a055930904346fb4248db";
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces/ab1accb4d2f4c72e63124f40681ad73bb02ac0f4";
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
        (inputs.nvf.lib.neovimConfiguration {
          pkgs = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
          modules = [
            ./modules/shared/nvf
          ];
        })
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
