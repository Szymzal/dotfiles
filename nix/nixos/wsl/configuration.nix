{ inputs, pkgs, ... }:  {
  imports = [
    inputs.self.nixosModules.common
    inputs.nixos-wsl.nixosModules.default

    ../../../users/szymzal
  ];

  environment.systemPackages = with pkgs; [
    home-manager
  ];

  # WSL stuff
  nixpkgs.hostPlatform = "x86_64-linux";

  wsl.enable = true;
  wsl.defaultUser = "szymzal";
}
