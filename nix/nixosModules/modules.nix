{ ... }: {
  imports = [
    ./homeManager.nix
    ./fonts.nix
    ./impermanence.nix
    ./shell.nix
    ./sops.nix
    ./sound.nix
    ./wm.nix
    ./dm
    ./desktop.nix
    ./wireshark.nix
    ./compression.nix

    ../../users/szymzal
  ];
}
