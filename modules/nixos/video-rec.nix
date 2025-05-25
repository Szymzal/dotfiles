{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mypackages.video-recording;

  distroav = pkgs.obs-studio-plugins.obs-ndi.overrideAttrs (_: rec {
    pname = "distroav";
    version = "6.0.0";

    src = pkgs.fetchFromGitHub {
      owner = "DistroAV";
      repo = "DistroAV";
      rev = version;
      sha256 = "sha256-pr/5XCLo5fzergIQrYFC9o9K+KuP4leDk5/oRe5ct9Q=";
    };

    patches = [
      ../../pkgs/hardcode-ndi-path.patch
    ];
  });
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
      plugins = [
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
