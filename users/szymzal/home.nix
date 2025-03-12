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

  home = {
    username = "szymzal";
    homeDirectory = "/home/szymzal";

    stateVersion = "23.11";
  };

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
      wallpaper-path = pkgs.fetchurl {
        name = "wallpaper";
        url = "https://raw.githubusercontent.com/DenverCoder1/minimalistic-wallpaper-collection/main/images/dalle2-minimalistic-colorful-flat-mountain-landscape.png";
        hash = "sha256-ON54b7rzocXoFXKQmfAuG4xXaC2AUH1r1x6m4YqnNIs=";
      };
      splash = false;
    };
    coding.enable = true;
    notes.enable = true;
    file-explorer.enable = true;
    communication.enable = false;
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
    password-manager.enable = true;
    linux-show-player.enable = true;
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
      lethalCompany.enable = true;
    };
    zoom.enable = false; # use chromium for zoom PWA
    blender.enable = true;
    epic-games.enable = true;
    zotero.enable = false;
    audio-mix.enable = true;
    cad.enable = false;
    email.enable = true;
    showExperiments.enable = true;
  };
}
