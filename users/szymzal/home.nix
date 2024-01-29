{ inputs, isDesktop, lib, ... }: 
let
  inherit (inputs) self;
in
{
  imports = [
    self.homeModules.common
    self.homeModules.coding
  ] ++ lib.optionals isDesktop [
    self.homeModules.desktop
  ];

  home.username = "szymzal";
  home.homeDirectory = "/home/szymzal";

  home.stateVersion = "23.11";

  home.packages = [];

  home.file = {};

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
