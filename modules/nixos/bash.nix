{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mypackages.shell;
in {
  # Fallback
  config = mkIf (!cfg.disableBash && !cfg.enable) {
    environment.systemPackages = with pkgs; [
      bash
    ];
  };
}
