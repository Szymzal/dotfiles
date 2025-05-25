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
    programs.obs-studio = {
      enable = true;
      plugins = [
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
