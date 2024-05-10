{ ... }: {
  imports = [
    ./lib.nix
    ./cachix.nix
    ./gc.nix
    ./bash.nix
    ./clipboard.nix
    ./monitors.nix
    ./multiTerminal.nix
    ./git.nix
    ./homeManager.nix
    ./fonts.nix
    ./impermanence.nix
    ./shell.nix
    ./sops.nix
    ./sound.nix
    ./wm.nix
    ./dm.nix
    ./cd.nix
    ./ls.nix
    ./find.nix
    ./wireshark.nix
    ./compression.nix
    ./nix.nix
    ./android.nix
    ./notes.nix
    ./coding.nix
    ./unfree.nix
    ./xbox.nix
    ./nvidia.nix
    ./editor.nix
    ./gtk.nix
    ./theme.nix
    ./catppuccin-hyprcursor

    ../../users/szymzal
  ];
}
