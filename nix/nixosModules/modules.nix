{ ... }: {
  imports = [
    ./lib.nix
    ./cachix.nix
    ./casparcg.nix
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
    ./dm
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
    ./file-explorer.nix
    ./nvidia.nix
    ./editor.nix
    ./gtk.nix
    ./theme.nix
    ./mouse.nix
    ./bottles.nix
    ./network.nix
    ./printing.nix
    ./bluetooth.nix
    ./networkmanager.nix
    ./videoediting.nix

    ./games/minecraft.nix

    ../../users/szymzal
  ];
}
