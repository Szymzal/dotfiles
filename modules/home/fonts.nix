{
  lib,
  osConfig,
  ...
}:
with lib; let
  cfg = osConfig.mypackages.fonts;
in {
  config = mkIf cfg.enable {
    mypackages.impermanence.directories = [".local/share/fonts"];
  };
}
