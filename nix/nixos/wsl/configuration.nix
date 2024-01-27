{ inputs, pkgs, ... }:
let
  inherit (inputs) self;
in
{
  imports = [
    self.nixosModules.common
    inputs.nixos-wsl.nixosModules.default

    ../../../users/szymzal
  ];

  # TODO: Is that really needed?
  # Would it not be enough for only in common.nix?
  environment.systemPackages = with pkgs; [
    home-manager
  ];

  # WSL stuff
  nixpkgs.hostPlatform = "x86_64-linux";

  wsl.enable = true;
  wsl.defaultUser = "szymzal";
}
