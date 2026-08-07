{
  lib,
  config,
  pkgs,
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
      pkgs.affinity-v3
    ];

    mypackages.impermanence.directories = [
      ".local/share/affinity-v3"
    ];
  };
}
