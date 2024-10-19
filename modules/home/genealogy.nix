{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.mypackages.genealogy;
in
{
  options = {
    mypackages.genealogy = {
      enable = mkEnableOption "Enable genealogy software";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gramps
    ];

    mypackages.impermanence.directories = [
      ".config/gramps"
      ".local/share/gramps"
    ];
  };
}
