{ config, lib, inputs, ... }:

{
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  wsl.enable = true;
  wsl.defaultUser = "szymzal";
}
