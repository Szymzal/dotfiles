{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.mypackages.ls;
in
{
  options = {
    mypackages.ls = {
      enable = mkEnableOption "Enable ls replacement";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      eza
    ];
  };
}
