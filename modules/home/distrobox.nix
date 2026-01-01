{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mypackages.distrobox;
in {
  options = {
    mypackages.distrobox = {
      enable = mkEnableOption "Enable Distrobox";
    };
  };

  config = mkIf cfg.enable {
    programs.distrobox.enable = true;

    mypackages.impermanence = {
      directories = [
      ];
    };
  };
}
