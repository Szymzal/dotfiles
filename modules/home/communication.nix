{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.mypackages.communication;
in {
  options = {
    mypackages.communication = {
      enable = mkEnableOption "Enable communication app (e.g. discord)";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (webcord.override {electron = pkgs.electron_32;}) # NOTE: Downgraded electron to make screen share work again
    ];

    mypackages.impermanence = {
      directories = [
        ".config/WebCord"
      ];
    };
  };
}
