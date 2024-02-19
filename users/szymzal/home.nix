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
  ];

  home.file = {
    ".zshrc".text = "";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.persistence."/persist/home/szymzal" = {
    directories = [
      ".ssh"
      ".config/sops"
      ".mozilla"
    ];
    files = [

    ];
    allowOther = true;
  };

  programs.home-manager.enable = true;
}
