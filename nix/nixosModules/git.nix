{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.mypackages.git;
in
{
  options = {
    mypackages.git = {
      enable = mkEnableOption "Enable git";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      git
    ];
  };
}
