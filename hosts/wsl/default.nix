{ config, lib, inputs, ... }: 

{

  imports = [
    ../../core
    ./wsl.nix   
    ./packages.nix

    ../../users/szymzal
  ];

  system.stateVersion = "23.11";
}
