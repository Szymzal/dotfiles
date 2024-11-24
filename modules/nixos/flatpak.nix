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
    inputs.flatpak.nixosModules.declarative-flatpak
  ];

  options = {
    mypackages.flatpak = {
      enable = mkEnableOption "Enable flatpak";
    };
  };

  config = mkIf cfg.enable {
    services.flatpak.enable = true;

    mypackages.impermanence.directories = [
      "/var/lib/flatpak"
    ];
  };
}
