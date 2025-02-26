{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.mypackages.password-manager;
  pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in {
  options = {
    mypackages.password-manager = {
      enable = mkEnableOption "Enable Password Manager";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs-unstable; [
      proton-pass
    ];

    mypackages.impermanence.directories = [
      ".config/Proton Pass"
    ];
  };
}
