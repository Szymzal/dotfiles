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

  home.username = "szymzal";
  home.homeDirectory = "/home/szymzal";

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  mypackages = {
    git = {
      enable = true;
      userName = "Szymzal";
      userEmail = "szymzal05@gmail.com";
    };
    impermanence = {
      enable = true;
      persistent-path = "/persist/home/szymzal";
      directories = [
        "Documents"
        "speedrunigt"
        ".config/sops"
        ".ssh"
        {
          directory = "dev";
          method = "symlink";
        }
        ".cargo"
      ];
    };
    ags.enable = true;
    launcher.enable = true;
    status-bar.enable = true;
    terminal.enable = true;
    tmux.enable = true;
    wm = {
      enable = true;
      preset = "river";
      wallpaper-path = pkgs.fetchurl {
        name = "wallpaper";
        url = "https://blogger.googleusercontent.com/img/a/AVvXsEjwg2vHBZqvGkQYUVq6o43OIK5dz7ShydmR-ns1tBE6MGivSQPU5VhCQCRVsB9gGzf8St-1CcTrGvc7Suzdi3XVm1tsadXSGV2qYzo3RM2jzrEq6-18X6upzutCYi2ouWBmTxkq40S0znT1yAJqovD68oRYHVPEw3VMz8fXiH5M-luJbSLnPTR4cSnx734=s1600-rw";
        hash = "sha256-3PzS16G5G7c3LBnW03eZl44Sl9JwzK4z0gUk6EI/JzY=";
      };
      splash = false;
    };
    coding.enable = true;
    notes.enable = true;
    file-explorer.enable = true;
    communication.enable = true;
    browser.enable = true;
    viewers.enableAll = true;
    image-editors.enable = true;
    screenshot = {
      enable = true;
      savePicturesPath = "Pictures/Screenshots";
    };
    cd.enable = true;
    ls.enable = true;
    find.enable = true;
    notifications.enable = true;
    office.enable = true;
    video-recording.enable = true;
    calendar.enable = false;
    bottles.enable = true;
    casparcg-client.enable = true;
    video-editing.enable = true;
    ldtk.enable = true;
    flatpak.enable = true;
    godot.enable = true;
    playit.enable = true;
    genealogy.enable = true;
    theme = {
      enable = true;
      inherit (osConfig.mypackages.theme) prefer-dark-theme theme iconTheme cursorTheme;
    };
    games = {
      terraria.enable = true;
      rocket-league.enable = true;
      roblox.enable = true;
      ets2.enable = true;
      openttd.enable = true;
      trackmania.enable = true;
    };
    zoom.enable = false; # use chromium for zoom PWA
    blender.enable = true;
    epic-games.enable = true;
    zotero.enable = true;
  };
}
