{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mypackages.office;
in {
  options = {
    mypackages.office = {
      enable = mkEnableOption "Enable Office suite";
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      # TODO: When fixed:
      # https://nixpk.gs/pr-tracker.html?pr=357555
      # libreoffice-fresh
      pdfarranger
    ];

    mypackages.impermanence.directories = [
      ".config/libreoffice"
    ];
  };
}
