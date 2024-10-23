{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mypackages.android;
in {
  options = {
    mypackages.android = {
      enable = mkEnableOption "Enable android tools";
    };
  };

  config = mkIf cfg.enable {
    programs.adb.enable = true;

    environment.systemPackages = with pkgs; [
      jmtpfs
    ];
  };
}
