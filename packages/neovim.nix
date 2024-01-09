{ config, lib, pkgs, inputs, ... }:

{

  imports = [
    inputs.nixvim.homeManagerModules.nixvim;
  ];

}
