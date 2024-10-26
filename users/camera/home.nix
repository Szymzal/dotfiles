{
  inputs,
  osConfig,
  pkgs,
  ...
}: let
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
      wallpaper-path = pkgs.fetchurl {
        url = "https://wallpapers.com/images/featured/solid-color-background-8hx8sccuk0vb8hpx.jpg";
        hash = "sha256-rxakSFAjnvFpXO0dEkdetiZpIDQxpQ0gPk/t1LRZszg=";
      };
      splash = false;
    };
    theme = {
      enable = true;
      inherit (osConfig.mypackages.theme) prefer-dark-theme theme iconTheme cursorTheme;
    };
    file-explorer.enable = true;
    browser.enable = true;
    notifications.enable = true;
  };
}
