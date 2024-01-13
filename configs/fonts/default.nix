{ config, lib, pkgs, nixpkgs, inputs, ... }:

{

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

}
