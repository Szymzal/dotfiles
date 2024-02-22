{ inputs, isDesktop, lib, pkgs, ... }: 
let
  inherit (inputs) self;
in
{
  imports = [
    self.homeModules.common
    self.homeModules.impermanence
    self.homeModules.coding
  ] ++ lib.optionals isDesktop [
    self.homeModules.desktop
  ];

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
    youtube-music
    xfce.thunar
    xfce.xfconf
    discord
  ];

  home.pointerCursor = {
    gtk.enable = true;
    name = "mocha-dark";
    size = 24;
    package = pkgs.catppuccin-cursors.mochaDark;
  };

  gtk = {
    enable = true;
  };

  home.file = {

  };

  # home.sessionVariables works only for bash NOT TESTED
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
    ];
    files = [

    ];
    allowOther = true;
  };

  programs.home-manager.enable = true;
}
