{ ... }: {
  imports = [
    ../../modules/nixos/lib.nix
    ../../modules/nixos/cachix.nix
    ../../modules/nixos/casparcg.nix
    ../../modules/nixos/gc.nix
    ../../modules/nixos/bash.nix
    ../../modules/nixos/clipboard.nix
    ../../modules/nixos/monitors.nix
    ../../modules/nixos/multiTerminal.nix
    ../../modules/nixos/git.nix
    ../../modules/nixos/homeManager.nix
    ../../modules/nixos/fonts.nix
    ../../modules/nixos/impermanence.nix
    ../../modules/nixos/shell.nix
    ../../modules/nixos/sops.nix
    ../../modules/nixos/sound.nix
    ../../modules/nixos/wm.nix
    ../../modules/nixos/dm
    ../../modules/nixos/cd.nix
    ../../modules/nixos/ls.nix
    ../../modules/nixos/find.nix
    ../../modules/nixos/wireshark.nix
    ../../modules/nixos/compression.nix
    ../../modules/nixos/nix.nix
    ../../modules/nixos/android.nix
    ../../modules/nixos/notes.nix
    ../../modules/nixos/coding.nix
    ../../modules/nixos/unfree.nix
    ../../modules/nixos/xbox.nix
    ../../modules/nixos/file-explorer.nix
    ../../modules/nixos/nvidia.nix
    ../../modules/nixos/editor.nix
    ../../modules/nixos/gtk.nix
    ../../modules/nixos/theme.nix
    ../../modules/nixos/mouse.nix
    ../../modules/nixos/bottles.nix
    ../../modules/nixos/network.nix
    ../../modules/nixos/printing.nix
    ../../modules/nixos/bluetooth.nix
    ../../modules/nixos/networkmanager.nix
    ../../modules/nixos/videoediting.nix

    ../../modules/nixos/games/minecraft.nix
    ../../modules/nixos/games/lutris.nix

    ../../users/szymzal
  ];
}
