{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.mypackages.affinity;
in {
  options = {
    mypackages.affinity = {
      enable = mkEnableOption "Enable Affinity Software";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      inputs.affinity-nix.packages.${pkgs.system}.v3
    ];

    mypackages.impermanence.directories = [
      ".local/share/affinity-v3"
    ];
  };
}
