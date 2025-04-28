{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.mypackages.video-editing;
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };
in {
  options = {
    mypackages.video-editing = {
      enable = mkEnableOption "Enable video editing program";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs-unstable; [
      davinci-resolve
    ];

    mypackages.impermanence.directories = [
      ".local/share/DaVinciResolve"
    ];
  };
}
