{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.mypackages.bottles;
in
{
  options = {
    mypackages.bottles = {
      enable = mkEnableOption "Enable bottles";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bottles
    ];
  };
}
