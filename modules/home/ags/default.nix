{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mypackages.ags;
in {
  options = {
    mypackages.ags = {
      enable = mkEnableOption "Enable AGS";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # TODO: Update to v2
      ags
    ];
  };
}
