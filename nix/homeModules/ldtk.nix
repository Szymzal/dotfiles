{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.mypackages.ldtk;
in
{
  options = {
    mypackages.ldtk = {
      enable = mkEnableOption "Enable LDTK";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ldtk
    ];

    mypackages.impermanence = [
      ".config/LDtk"
    ];
  };
}
