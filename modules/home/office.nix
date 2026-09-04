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

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      libreoffice-fresh
      pdfarranger
    ];

    # TODO: Make module for default apps
    xdg = {
      mime = {
        enable = mkDefault true;
      };
      mimeApps = {
        enable = mkDefault true;
        associations.added = let
          desktopFile = "com.github.jeromerobert.pdfarranger.desktop";
        in {
          "application/pdf" = [desktopFile];
        };
      };
    };

    mypackages.impermanence.directories = [
      ".config/libreoffice"
    ];
  };
}
