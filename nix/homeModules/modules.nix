{ ... }: {
  imports = [
    ./impermanence.nix
    ./git.nix
    ./launcher.nix
    ./statusBar.nix
    ./terminal.nix
    ./tmux.nix
    ./wm.nix
    ./coding
    ./cd.nix
    ./ls.nix
    ./find.nix
    ./notifications.nix
    ./file-explorer.nix
    ./communication.nix
    ./browser.nix
    ./image-editor.nix
    ./viewers.nix
    ./screenshot.nix
    ./notes.nix
    ./theme.nix
    ./calendar.nix
    ./bottles.nix
    ./network.nix

    ./games/minecraft.nix
  ];
}
