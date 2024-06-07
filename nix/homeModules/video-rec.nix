{ lib, config, ... }:
with lib;
let
  cfg = config.mypackages.video-recording;
in
{
  options = {
    mypackages.video-recording = {
      enable = mkEnableOption "Enable video recording";
    };
  };

  config = mkIf (cfg.enable) {
    programs.obs-studio.enable = true;
    mypackages.impermanence.directories = [
      "Videos"
    ];
  };
}
