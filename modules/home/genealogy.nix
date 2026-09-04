{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.mypackages.genealogy;
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs) system;
  };
in {
  options = {
    mypackages.genealogy = {
      enable = mkEnableOption "Enable genealogy software";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs-unstable; [
      gramps
    ];

    mypackages.impermanence.directories = [
      ".config/gramps"
      ".local/share/gramps"
    ];
  };
}
