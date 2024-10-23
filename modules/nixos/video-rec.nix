{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mypackages.video-recording;
in {
  options = {
    mypackages.video-recording = {
      enable = mkEnableOption "Enable video recording";
    };
  };

  config = mkIf (cfg.enable) {
    environment.systemPackages = with pkgs; [
      gpu-screen-recorder-gtk
    ];

    programs.gpu-screen-recorder.enable = true;
  };
}
