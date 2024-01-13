{ config, lib, pkgs, inputs, ... }:

let 
  szymzal-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "SzymzalConfig";
    src = ../configs/nvim;
  };
in
{

  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs; [
      vimPlugins.LazyVim

      szymzal-nvim
    ];

    extraConfig = ''
      lua << EOF
        require('SzymzalConfig').init()
      EOF
    '';

    extraPackages = with pkgs; [
      git
      gcc
      lazygit
      ripgrep
      fd
    ];
  };

}
