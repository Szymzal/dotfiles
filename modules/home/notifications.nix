{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mypackages.notifications;
in {
  options = {
    mypackages.notifications = {
      enable = mkEnableOption "Enable notification deamon";
    };
  };

  config = mkIf cfg.enable {
    services.dunst.enable = true;

    mypackages.impermanence.directories = [
      ".config/dunst"
    ];
  };
}
