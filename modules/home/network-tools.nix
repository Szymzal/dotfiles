{
  lib,
  osConfig,
  ...
}:
with lib; {
  config = mkIf osConfig.mypackages.network-tools.enable {
    mypackages.impermanence.directories = [
      ".config/filezilla"
    ];
  };
}
