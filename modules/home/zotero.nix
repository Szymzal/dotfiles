{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mypackages.zotero;
in {
  options = {
    mypackages.zotero = {
      enable = mkEnableOption "Enable Zotero";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      zotero
    ];

    mypackages.impermanence.directories = ["Zotero"];
  };
}
