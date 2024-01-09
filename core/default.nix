{ config, lib, pkgs, nixpkgs, inputs, ... }:

{

  imports = [
    inputs.home-manager.nixosModules.default
    ../packages/tmux.nix
    ../packages/zsh.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    bash
    neovim
  ];

}
