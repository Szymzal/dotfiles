{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mypackages.wireshark;
in {
  options = {
    mypackages.wireshark = {
      enable = mkEnableOption "Enable wireshark";
    };
  };

  config = mkIf cfg.enable {
    programs.wireshark = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      wireshark
    ];
  };
}
