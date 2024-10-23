{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mypackages.video-editing;
in {
  options = {
    mypackages.video-editing = {
      enable = mkEnableOption "Enable video editing program";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      davinci-resolve
    ];

    mypackages.impermanence.directories = [
      "Documents/BlackmagicDesign"
      ".local/share/DaVinciResolve"
    ];
  };
}
