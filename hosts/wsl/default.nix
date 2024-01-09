{ config, lib, inputs, ... }: 

{

  imports = [
    ../../core
    ./wsl.nix   
    ./packages.nix
  ];

  system.stateVersion = "23.11";
}
