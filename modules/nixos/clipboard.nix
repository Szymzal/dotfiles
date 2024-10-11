{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.mypackages.clipboard;
in
{
  options = {
    mypackages.clipboard = {
      enable = mkEnableOption "Enable clipboard";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wl-clipboard
    ];
  };
}
