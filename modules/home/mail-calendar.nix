{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.mypackages.mail;
  pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in {
  options = {
    mypackages.mail = {
      enable = mkEnableOption "Enable Mail/Calendar App";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      protonmail-desktop
    ];

    mypackages.impermanence.directories = [
    ];
  };
}
