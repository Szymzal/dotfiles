{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.mypackages.winboat;
in {
  options = {
    mypackages.winboat = {
      enable = mkEnableOption "Enable Winboat";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      inputs.winboat.packages."${pkgs.system}".winboat
      pkgs.docker-compose
      pkgs.freerdp
    ];

    # For some reason podman is not supported
    virtualisation.docker.enable = true;

    mypackages.impermanence.directories = [
      "/srv/winboat"
    ];
  };
}
