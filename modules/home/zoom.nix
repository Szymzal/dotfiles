{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.mypackages.zoom;
in
{
  options = {
    mypackages.zoom = {
      enable = mkEnableOption "Enable Zoom";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      zoom-us
    ];

    mypackages.impermanence.files = [
      ".config/zoom.conf"
      ".config/zoomus.conf"
    ];
  };
}
