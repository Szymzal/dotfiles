{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.mypackages.network-tools;
in
{
  options = {
    mypackages.network-tools = {
      enable = mkEnableOption "Enable network tools";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      inetutils
    ];
  };
}
