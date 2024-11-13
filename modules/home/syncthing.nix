{
  lib,
  osConfig,
  ...
}:
with lib; {
  config = mkIf osConfig.mypackages.syncthing.enable {
    mypackages.impermanence.directories = [".config/syncthing"];
  };
}
