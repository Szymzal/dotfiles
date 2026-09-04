{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mypackages.color-managment;
in {
  options = {
    mypackages.color-managment = {
      enable = mkEnableOption "Enable color managment";
    };
  };

  config = mkIf cfg.enable {
    services.colord.enable = true;

    mypackages.impermanence.directories = [
      {
        directory = "/var/lib/colord";
        user = "colord";
        group = "colord";
        mode = "u=rwx,g=rx,o=";
      }
    ];
  };
}
