{ inputs, pkgs, ... }:
let
  inherit (inputs) self;
in
{
  imports = [
    self.homeModules.modules
  ];

  mypackages.git = {
    enable = true;
    userName = "Szymzal";
    userEmail = "szymzal05@gmail.com";
  };
  mypackages.impermanence = {
    enable = true;
    persistent-path = "/persist/home/szymzal";
    directories = [
      ".ssh"
      "dev"
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
  mypackages.viewers.enableAll = true;
  mypackages.image-editors.enable = true;
  mypackages.screenshot = {
    enable = true;
    savePicturesPath = "Pictures/Screenshots";
  };
  mypackages.cd.enable = true;
  mypackages.ls.enable = true;
  mypackages.find.enable = true;
  mypackages.notifications.enable = true;
  mypackages.theme = {
    enable = true;
    prefer-dark-theme = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Blue-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        variant = "mocha";
      };
    };
    cursorTheme = {
      name = "Catppuccin-Mocha-Dark-Cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 24;
    };
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
  };

  home.username = "szymzal";
  home.homeDirectory = "/home/szymzal";

  home.stateVersion = "23.11";

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
    ];
    files = [

    ];
    allowOther = true;
  };

  programs.home-manager.enable = true;
}
