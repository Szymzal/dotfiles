{ config, lib, pkgs, inputs, ... }:

{

  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraPackages = with pkgs; [
      git
      gcc
      lazygit
      ripgrep
      fd

      rust-analyzer
    ];
  };

}
