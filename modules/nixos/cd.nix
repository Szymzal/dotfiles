{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.mypackages.cd;
in
{
  options = {
    mypackages.cd = {
      enable = mkEnableOption "Enable cd replacement";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      zoxide
    ];
  };
}
