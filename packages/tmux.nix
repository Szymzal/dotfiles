{ config, lib, pkgs, ... }:

{

  programs.tmux = {
    enable = true;
    escapeTime = 50;
    extraConfig = "set -g default-terminal \"xterm-256color\"\nset-option -ga terminal-overrides \",xterm-256color:Tc\"";
  };

}
