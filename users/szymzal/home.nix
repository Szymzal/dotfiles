{ inputs, pkgs, ... }:
let
  inherit (inputs) self;
in
{
  imports = [
    self.homeModules.modules
  ];

  mypackages.git.enable = true;
  mypackages.impermanence = {
    enable = true;
    persistent-path = "/persist/home/szymzal";
    directories = [
      ".ssh"
      "dev"
      "Downloads"
      ".cargo"
    ];
  };
  mypackages.launcher.enable = true;
  mypackages.status-bar.enable = true;
  mypackages.terminal.enable = true;
  mypackages.tmux.enable = true;
  mypackages.wm = {
    enable = true;
    wallpaper-path = "/persist/nixos/wallpaper.jpg";
    splash = false;
  };
  mypackages.coding.enable = true;
  mypackages.notes.enable = true;
  mypackages.file-explorer.enable = true;
  mypackages.communication.enable = true;
  mypackages.browser.enable = true;

  home.username = "szymzal";
  home.homeDirectory = "/home/szymzal";

  home.stateVersion = "23.11";

  programs.git = {
    userName = "Szymzal";
    userEmail = "szymzal05@gmail.com";
  };

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
    # TODO: resolve those (connection between nixos and home-manager modules)
    directories = [
      ".config/sops"
      ".local/share/Steam"
      ".local/share/bottles"
      ".local/share/PrismLauncher"
      ".local/share/Rocket League"
      ".config/r2modman"
      ".config/r2modmanPlus-local"
      "Games"
    ];
    files = [

    ];
    allowOther = true;
  };

  programs.home-manager.enable = true;
}
