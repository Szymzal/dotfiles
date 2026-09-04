{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mypackages.showExperiments;
in {
  options = {
    mypackages.showExperiments = {
      enable = mkEnableOption "Enable show experiments";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      chataigne
    ];

    mypackages.impermanence.directories = [
    ];
  };
}
