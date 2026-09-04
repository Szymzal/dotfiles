{
  lib,
  osConfig,
  ...
}:
with lib; let
  cfg = osConfig.mypackages.onedrive;
in {
  config =
    mkIf cfg.enable {
    };
}
