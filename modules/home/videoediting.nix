{
  lib,
  config,
  pkgs,
  inputs,
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
      kdePackages.kdenlive
    ];

    mypackages.impermanence.directories = [
      ".local/share/DaVinciResolve"
    ];
  };
}
