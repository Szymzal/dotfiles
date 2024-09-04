{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.mypackages.blender;
in
{
  options = {
    mypackages.blender = {
      enable = mkEnableOption "Enable Blender";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      blender
    ];
  };
}
