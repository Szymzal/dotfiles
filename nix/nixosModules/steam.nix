{ pkgs, ... }: {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    steam-run
    steam-tui
    steamPackages.steamcmd
    (steam.override { extraPkgs = pkgs: [ mono gtk3 gtk3-x11 libgdiplus zlib ]; })
    # (steam.override { withPrimus = true; extraPkgs = pkgs: [ bumblebee glxinfo ]; })
    # (steam.override { withJava = true; })
  ];
}
