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
    environment.systemPackages = with pkgs; [
      gpu-screen-recorder-gtk
      v4l-utils
    ];

    programs.gpu-screen-recorder.enable = true;
    programs.obs-studio = {
      enable = true;
      enableVirtualCamera = true;
      plugins = with pkgs-unstable.obs-studio-plugins; [
        distroav
      ];
    };

    boot = {
      kernelModules = ["v4l2loopback"];
      extraModulePackages = with config.boot.kernelPackages; [
        v4l2loopback
      ];
      extraModprobeConfig = ''
        options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
      '';
    };

    security.polkit.enable = true;
  };
}
