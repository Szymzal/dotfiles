{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.mypackages.find;
in
{
  options = {
    mypackages.find = {
      enable = mkEnableOption "Enable find replacement";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      fd
    ];
  };
}
