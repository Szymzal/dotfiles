{
  lib,
  osConfig,
  ...
}:
with lib; {
  config = mkIf osConfig.mypackages.sunshine.enable {
    mypackages.impermanence.directories = [".config/sunshine"];
  };
}
