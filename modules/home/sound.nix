{
  lib,
  osConfig,
  ...
}:
with lib; {
  config = mkIf osConfig.mypackages.sound.enable {
    mypackages.impermanence.directories = [".config/rncbc.org"];
  };
}
