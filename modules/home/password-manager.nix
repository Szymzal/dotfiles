{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mypackages.password-manager;
in {
  options = {
    mypackages.password-manager = {
      enable = mkEnableOption "Enable Password Manager";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs.pkgs-unstable; [
      proton-pass
    ];

    mypackages.impermanence.directories = [
      ".config/Proton Pass"
    ];
  };
}
