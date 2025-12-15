{
  lib,
  osConfig,
  ...
}:
with lib; {
  config = mkIf osConfig.mypackages.virtualization.enable {
    mypackages.impermanence.directories = [
      ".vmware"
    ];
  };
}
