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
    services.flatpak = {
      packages = cfg.packages;
    };

    mypackages.impermanence.directories = [
      ".local/share/flatpak"
      ".local/state/flatpak-module"
      ".var/app"
    ];
  };
}
