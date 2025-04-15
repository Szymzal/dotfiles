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

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix/release-24.11";

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    nvf.url = "github:NotAShelf/nvf/?ref=585dfca7ca75c8190bd1596f3ebc6fde6751c7a5";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    hyprland.url = "github:hyprwm/Hyprland";
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
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
