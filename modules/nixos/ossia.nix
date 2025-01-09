{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mypackages.ossia;
in {
  options = {
    mypackages.ossia = {
      enable = mkEnableOption "Enable Ossia Score Sequencer";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ossia-score
    ];
  };
}
