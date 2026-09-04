{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mypackages.plakativ;
in {
  options = {
    mypackages.plakativ = {
      enable = mkEnableOption "Enable plakativ";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      plakativ
    ];
  };
}
