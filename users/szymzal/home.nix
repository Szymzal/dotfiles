{ inputs, pkgs, ... }:
let
  inherit (inputs) self;
in
{
  imports = [
    self.homeModules.modules
    # self.homeModules.common
    # self.homeModules.impermanence
    # self.homeModules.coding
    # self.homeModules.desktop
  ];

  mypackages.git.enable = true;
  mypackages.impermanence.enable = true;
  mypackages.launcher.enable = true;
  mypackages.status-bar.enable = true;
  mypackages.terminal.enable = true;
  mypackages.tmux.enable = true;
  mypackages.wm.enable = true;
  mypackages.coding.enable = true;

  home.username = "szymzal";
  home.homeDirectory = "/home/szymzal";

  home.stateVersion = "23.11";

  programs.firefox = {
    enable = true;
  };

  programs.git = {
    userName = "Szymzal";
    userEmail = "szymzal05@gmail.com";
  };

  home.packages = with pkgs; [
    xfce.thunar
    xfce.xfconf
    webcord
  ];

  home.pointerCursor = {
    gtk = {
      enable = true;
    };
    name = "mocha-dark";
    size = 24;
    package = pkgs.catppuccin-cursors.mochaDark;
  };

  home.file = {

  };

  # home.sessionVariables works only for bash. NOT TESTED
  programs.zsh = {
    enable = true;
    sessionVariables = {

    };
  };

  home.persistence."/persist/home/szymzal" = {
    directories = [
      ".ssh"
      ".config/sops"
      ".config/discord"
      ".mozilla"
      ".steam"
      ".local/share/Steam"
      ".local/share/bottles"
      ".local/share/PrismLauncher"
      ".local/share/Rocket League"
      ".config/r2modman"
      ".config/r2modmanPlus-local"
      ".config/Thunar"
      ".config/xfce4"
      "dev"
      "Pobrane"
    ];
    files = [

    ];
    allowOther = true;
  };

  programs.home-manager.enable = true;
}
