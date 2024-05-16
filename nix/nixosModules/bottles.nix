{ lib, config, pkgs, ... }:
with lib;
let
  myLib = config.lib.myLib;
  cfg = config.mypackages.bottles;
in
{
  options = {
    mypackages.bottles = {
      enable = mkEnableOption "Enable bottles";
    };
  };

  config = mkIf (((myLib.isEnabledOptionOnHomeConfig "mypackages.notes.enable") && config.home-manager.useGlobalPkgs) || cfg.enable) {
    environment.systemPackages = with pkgs; [
      bottles
    ];
  };
}
