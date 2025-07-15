{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.mypackages.video-recording;
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };
in {
  options = {
    mypackages.video-recording = {
      enable = mkEnableOption "Enable video recording";
    };
  };

  config = mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs-unstable.obs-studio-plugins; [
        distroav
      ];
    };

    mypackages.impermanence.directories = [
      ".config/gpu-screen-recorder"
      ".config/obs-studio"
      "Videos"
    ];
  };
}
