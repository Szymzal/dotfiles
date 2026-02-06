{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    flakelight = {
      url = "github:nix-community/flakelight";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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
    stylix.url = "github:danth/stylix/release-25.11";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    flatpak.url = "github:gmodena/nix-flatpak/latest";
    nvf.url = "github:NotAShelf/nvf/v0.8";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    hyprland = {
      url = "github:hyprwm/Hyprland/v0.53.1";
      # url = "github:hyprwm/Hyprland/386376400119dd46a767c9f8c8791fd22c7b6e61";
      # FIXME: Wait for it to be resolved:
      # - https://github.com/hyprwm/Hyprland/discussions/13043
      # - https://github.com/hyprwm/Hyprland/pull/13048
      # url = "github:hyprwm/Hyprland/efe665b4558370af6e89921c487cd92890183961";
    };
    astal.url = "github:Aylur/astal";
    hyprsplit = {
      # url = "github:shezdy/hyprsplit/18fd958b946aa05196d5341fccfd4c63130918b0";
      # url = "github:shezdy/hyprsplit/d8585473531b24c23794b060d9fe2f5f89b05563";
      url = "github:shezdy/hyprsplit/v0.53.1";
      inputs.hyprland.follows = "hyprland";
    };
    mango = {
      url = "github:DreamMaoMao/mango";
      inputs.nixpkgs.follows = "nixpkgs";
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
          pkgs-unstable = inputs.nvf.inputs.nixpkgs.legacyPackages.${pkgs.system};
        in {
          pkgs = pkgs-unstable;
          modules = [
            (import ./modules/shared/nvf {
              pkgs = pkgs-unstable;
              inherit (inputs.nixpkgs-unstable) lib;
            })
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
