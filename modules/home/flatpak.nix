{
  lib,
  config,
  inputs,
  ...
}:
with lib; let
  cfg = config.mypackages.flatpak;
in {
  imports = [
    inputs.flatpak.homeManagerModules.declarative-flatpak
  ];

  options = {
    mypackages.flatpak = {
      enable = mkEnableOption "Enable flatpak";
      packages = mkOption {
        type = types.listOf types.str;
        default = [];
      };
    };
  };

  config = mkIf cfg.enable {
    # does not work with declarative-flatpak, but works with nix-flatpak
    stylix.targets.gtk.flatpakSupport.enable = false;

    services.flatpak = {
      enableModule = true;
      remotes = {
        "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      };
      packages = cfg.packages;
    };

    mypackages.impermanence.directories = [
      ".local/share/flatpak"
      ".local/state/flatpak-module"
      ".var/app"
    ];
  };
}
