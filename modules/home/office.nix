{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.mypackages.office;
in
{
  options = {
    mypackages.office = {
      enable = mkEnableOption "Enable Office suite";
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      libreoffice-fresh
    ];

    mypackages.impermanence.directories = [
      ".config/libreoffice"
    ];
  };
}
