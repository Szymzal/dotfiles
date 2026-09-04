{
  inputs,
  osConfig,
  ...
}: let
  inherit (inputs) self;
in {
  imports = [
    self.homeModules.modules
  ];

  home.username = "admin";
  home.homeDirectory = "/home/admin";

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  mypackages = {
    git.enable = true;
    status-bar.enable = true;
    tmux.enable = true;
    theme = {
      enable = true;
      inherit (osConfig.mypackages.theme) prefer-dark-theme theme iconTheme cursorTheme;
    };
    impermanence = {
      enable = true;
      persistent-path = "/persist/home/szymzal";
      directories = [
        ".config/sops"
        ".ssh"
      ];
    };
  };
}
