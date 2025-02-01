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

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    nvf.url = "github:NotAShelf/nvf";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = {flakelight, ...} @ inputs: (flakelight ./. ({lib, ...}: {
    inherit inputs;

    outputs = {
      overlay = _: pkgs: (import ./pkgs {inherit pkgs;});
    };

    perSystem = pkgs: {
      packages.default =
        (inputs.nvf.lib.neovimConfiguration {
          inherit pkgs;
          modules = [
            ./modules/shared/nvf
          ];
        })
        .neovim;
    };

    withOverlays = [
      inputs.nix-minecraft.overlay
      (_: pkgs: (import ./pkgs {inherit pkgs;}))
    ];
    systems = lib.systems.flakeExposed;
  }));
}
