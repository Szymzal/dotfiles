{ lib, config, inputs, ... }:
with lib;
let
  cfg = config.mypackages.flatpak;
in
{
  imports = [
    inputs.flatpak.homeManagerModules.default
  ];

  options = {
    mypackages.flatpak = {
      enable = mkEnableOption "Enable flatpak";
      packages = mkOption {
        type = types.listOf types.str;
        default = [ ];
      };
    };
  };

  config = mkIf cfg.enable {
    services.flatpak.enableModule = true;

    services.flatpak.packages = cfg.packages;

    mypackages.impermanence.directories = [
      ".local/share/flatpak"
    ];
  };
}
