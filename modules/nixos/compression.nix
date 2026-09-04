{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mypackages.compression;
in {
  options = {
    mypackages.compression = {
      enable = mkEnableOption "Enable compression tools";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      unzip
    ];
  };
}
