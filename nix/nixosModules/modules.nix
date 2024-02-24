{ ... }: {
  imports = [
    ./homeManager.nix
    ./fonts.nix
    ./impermanence.nix
    ./lethalcompany.nix
    ./shell.nix
    ./sops.nix
    ./sound.nix
    ./steam.nix
    ./wm.nix
    ./dm
    ./desktop.nix

    ../../users/szymzal
  ];
}
