{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mypackages.gstreamer;
  use-shell = throw "USE SHELL!";
in {
  options = {
    mypackages.gstreamer = {
      enable = mkEnableOption "Enable gstreamer packages";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      use-shell
    ];
  };
}
