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
    inputs.flatpak.homeManagerModules.nix-flatpak
  ];

  options = {
    mypackages.flatpak = {
      enable = mkEnableOption "Enable flatpak";
      packages = mkOption {
        default = [];
      };
    };
  };

  config = mkIf cfg.enable {
    # does not work with declarative-flatpak, but works with nix-flatpak
    # stylix.targets.gtk.flatpakSupport.enable = false;

    services.flatpak = {
      # remotes = [{
      #   name = "flathub"; = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      # }];
      packages = cfg.packages;
    };

    mypackages.impermanence.directories = [
      ".local/share/flatpak"
      ".local/state/flatpak-module"
      ".var/app"
    ];
  };
}
