{inputs, ...}: let
  inherit (inputs) self;
in {
  imports = [
    self.homeModules.modules
  ];

  home.username = "camera";
  home.homeDirectory = "/home/camera";

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  mypackages = {
    git.enable = true;
    launcher.enable = true;
    status-bar.enable = true;
    terminal.enable = true;
    tmux.enable = true;
    wm = {
      enable = true;
      preset = "river";
      wallpaper-path = /persist/customization/wallpaper.jpg;
      splash = false;
    };
    file-explorer.enable = true;
    browser.enable = true;
    notifications.enable = true;
  };
}
